locals {
  inline_secret_names = {
    for env_name, _ in var.secret_env_vars :
    env_name => "inline-${substr(replace(replace(lower(env_name), "__", "-"), "_", "-"), 0, 50)}"
  }

  key_vault_secret_names = {
    for env_name, ref in var.key_vault_secret_refs :
    env_name => coalesce(
      try(ref.secret_name, null),
      "kv-${substr(replace(replace(lower(env_name), "__", "-"), "_", "-"), 0, 53)}",
    )
  }

  container_tags = merge(
    {
      managed_by = "terraform"
    },
    var.tags,
  )
}

resource "azurerm_container_app" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  revision_mode                = "Single"
  tags                         = local.container_tags

  identity {
    type = "SystemAssigned"
  }

  dynamic "secret" {
    for_each = var.secret_env_vars

    content {
      name  = local.inline_secret_names[secret.key]
      value = secret.value
    }
  }

  dynamic "secret" {
    for_each = var.key_vault_secret_refs

    content {
      name                = local.key_vault_secret_names[secret.key]
      key_vault_secret_id = secret.value.key_vault_secret_id
      identity            = "System"
    }
  }

  dynamic "secret" {
    for_each = var.registry == null ? [] : [var.registry]

    content {
      name                = secret.value.password_secret_name
      value               = try(secret.value.password_secret_value, null)
      key_vault_secret_id = try(secret.value.password_secret_key_vault_secret_id, null)
      identity = try(secret.value.password_secret_key_vault_secret_id, null) != null ? coalesce(
        try(secret.value.identity, null),
        "System",
      ) : null
    }
  }

  dynamic "registry" {
    for_each = var.registry == null ? [] : [var.registry]

    content {
      server               = registry.value.server
      username             = registry.value.username
      password_secret_name = registry.value.password_secret_name
    }
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = var.name
      image  = var.image
      cpu    = var.cpu
      memory = var.memory

      dynamic "env" {
        for_each = var.env_vars

        content {
          name  = env.key
          value = env.value
        }
      }

      dynamic "env" {
        for_each = var.secret_env_vars

        content {
          name        = env.key
          secret_name = local.inline_secret_names[env.key]
        }
      }

      dynamic "env" {
        for_each = var.key_vault_secret_refs

        content {
          name        = env.key
          secret_name = local.key_vault_secret_names[env.key]
        }
      }
    }
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = var.target_port

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].container[0].image,
    ]
  }
}
