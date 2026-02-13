variable "policy_name" {
  type = string
}

resource "elasticstack_fleet_agent_policy" "test_policy" {
  name            = var.policy_name
  namespace       = "default"
  description     = "TestAccIntegrationPolicyElasticDefend Agent Policy"
  monitor_logs    = true
  monitor_metrics = true
  skip_destroy    = false
}

data "elasticstack_fleet_integration" "endpoint" {
  name = "endpoint"
}

resource "elasticstack_fleet_integration_policy" "test_policy" {
  name                = var.policy_name
  namespace           = "default"
  agent_policy_id     = elasticstack_fleet_agent_policy.test_policy.id
  integration_name    = "endpoint"
  integration_version = data.elasticstack_fleet_integration.endpoint.version
  description         = "Elastic Defend Integration Policy"

  inputs = {
    "endpoint-endpoint" = {
      enabled = true
      config_json = jsonencode({
        "policy" = {
          "value" = {
            "windows" = {
              "events" = {
                "dll_and_driver_load" = true,
                "dns"                 = true,
                "file"                = true,
                "network"             = true,
                "process"             = true,
                "registry"            = true,
                "security"            = true
              },
              "malware" = {
                "mode" = "prevent"
              }
            },
            "mac" = {
              "events" = {
                "file"    = true,
                "network" = true,
                "process" = true
              },
              "malware" = {
                "mode" = "prevent"
              }
            },
            "linux" = {
              "events" = {
                "file"    = true,
                "network" = true,
                "process" = true
              },
              "malware" = {
                "mode" = "prevent"
              }
            }
          }
        }
      })
    }
  }
}
