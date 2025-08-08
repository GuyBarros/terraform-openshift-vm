resource "kubernetes_manifest" "kubevirt_vm" {
  manifest = {
    apiVersion = "kubevirt.io/v1"
    kind       = "VirtualMachine"
    metadata = {
      name      = var.vm_name
      namespace = var.namespace
      annotations = {
        "vm.kubevirt.io/validations" = jsonencode([
          {
            name    = "minimal-required-memory"
            path    = "jsonpath::.spec.domain.memory.guest"
            rule    = "integer"
            message = "This VM requires more memory."
            min     = var.min_memory_bytes
          }
        ])
      }
      labels = {
        app                                       = var.vm_name
        "kubevirt.io/dynamic-credentials-support" = tostring(var.dynamic_credentials_support)
        "vm.kubevirt.io/template"                 = var.vm_template
        "vm.kubevirt.io/template.namespace"       = var.vm_template_namespace
        "vm.kubevirt.io/template.revision"        = var.vm_template_revision
        "vm.kubevirt.io/template.version"         = var.vm_template_version
        "vm.openshift.io/folder"                  = var.folder
      }
    }
    spec = {
      dataVolumeTemplates = [
        {
          apiVersion = "cdi.kubevirt.io/v1beta1"
          kind       = "DataVolume"
          metadata = {
            name = var.vm_name
          }
          spec = {
            sourceRef = {
              kind      = "DataSource"
              name      = var.datasource_name
              namespace = var.datasource_namespace
            }
            storage = {
              resources = {
                requests = {
                  storage = var.disk_size
                }
              }
            }
          }
        }
      ]
      runStrategy = var.run_strategy
      template = {
        metadata = {
          annotations = {
            "vm.kubevirt.io/flavor"   = var.vm_flavor
            "vm.kubevirt.io/os"       = var.vm_os
            "vm.kubevirt.io/workload" = var.vm_workload
          }
          labels = {
            "kubevirt.io/domain"                  = var.vm_name
            "kubevirt.io/size"                    = var.vm_size
            "network.kubevirt.io/headlessService" = var.headless_service
          }
        }
        spec = {
          architecture = var.architecture
          domain = {
            cpu = {
              cores   = var.cpu_cores
              sockets = var.cpu_sockets
              threads = var.cpu_threads
            }
            devices = {
              disks = [
                {
                  disk = {
                    bus = var.disk_bus
                  }
                  name = "rootdisk"
                },
                {
                  disk = {
                    bus = var.disk_bus
                  }
                  name = "cloudinitdisk"
                }
              ]
              interfaces = [
                {
                  macAddress = var.mac_address
                  masquerade = {}
                  model      = var.network_model
                  name       = "default"
                }
              ]
              rng = {}
            }
            features = {
              acpi = {}
              smm = {
                enabled = var.smm_enabled
              }
            }
            firmware = {
              bootloader = {
                efi = {}
              }
            }
            machine = {
              type = var.machine_type
            }
            memory = {
              guest = var.memory
            }
            resources = {}
          }
          networks = [
            {
              name = "default"
              pod  = {}
            }
          ]
          terminationGracePeriodSeconds = var.termination_grace_period
          volumes = [
            {
              dataVolume = {
                name = var.vm_name
              }
              name = "rootdisk"
            },
            {
              cloudInitNoCloud = {
                userData = join("\n", [
                  "#cloud-config",
                  "user: ${var.cloud_user}",
                  "password: ${var.cloud_password}",
                  "chpasswd: { expire: ${var.password_expire ? "True" : "False"} }"
                ])
              }
              name = "cloudinitdisk"
            }
          ]
        }
      }
    }
  }
}
