# OpenShift Virtual Machine RHEL
Module to create RHEL, CentOS Stream, and Fedora virtual machine on an OpenShift Virtualization platform.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.5 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.19 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.38 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_http"></a> [http](#provider\_http) | 3.5.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.19.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.kubevirt_vm](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.service_account](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.ssh_internal_service](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [random_password.vm_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_uuid.vm_uuid](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [http_http.ssh_ca_public_key](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [kubernetes_service_v1.ssh_internal_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service_v1) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_user"></a> [cloud\_user](#input\_cloud\_user) | Default cloud-init user | `string` | `"cloud-user"` | no |
| <a name="input_cloud_user_password"></a> [cloud\_user\_password](#input\_cloud\_user\_password) | Password for the cloud-init user (auto-generated if not provided) | `string` | `""` | no |
| <a name="input_cluster_api_url"></a> [cluster\_api\_url](#input\_cluster\_api\_url) | OpenShift API URL | `string` | n/a | yes |
| <a name="input_cluster_insecure_skip_tls_verify"></a> [cluster\_insecure\_skip\_tls\_verify](#input\_cluster\_insecure\_skip\_tls\_verify) | Skip TLS verification for the OpenShift API | `bool` | `true` | no |
| <a name="input_cluster_token"></a> [cluster\_token](#input\_cluster\_token) | OpenShift cluster authentication token | `string` | n/a | yes |
| <a name="input_cpu_cores"></a> [cpu\_cores](#input\_cpu\_cores) | Number of CPU cores per socket | `number` | `1` | no |
| <a name="input_cpu_sockets"></a> [cpu\_sockets](#input\_cpu\_sockets) | Number of CPU sockets | `number` | `2` | no |
| <a name="input_cpu_threads"></a> [cpu\_threads](#input\_cpu\_threads) | Number of threads per core | `number` | `1` | no |
| <a name="input_datasource_name"></a> [datasource\_name](#input\_datasource\_name) | Name of the datasource for the VM image (e.g., rhel9, rhel8, centos-stream9) | `string` | `"rhel9"` | no |
| <a name="input_datasource_namespace"></a> [datasource\_namespace](#input\_datasource\_namespace) | Namespace of the datasource | `string` | `"openshift-virtualization-os-images"` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Root disk size (e.g., '30Gi') | `string` | `"30Gi"` | no |
| <a name="input_flavor"></a> [flavor](#input\_flavor) | VM flavor | `string` | `"small"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | QEMU machine type | `string` | `"pc-q35-rhel9.4.0"` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Guest memory allocation (e.g., '4Gi') | `string` | `"4Gi"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the virtual machine (also used as hostname) | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace for the VM | `string` | `"default"` | no |
| <a name="input_run_strategy"></a> [run\_strategy](#input\_run\_strategy) | VM run strategy (Halted, RerunOnFailure, Always) | `string` | `"RerunOnFailure"` | no |
| <a name="input_service_account_binding"></a> [service\_account\_binding](#input\_service\_account\_binding) | Binds a Service Account identity to the virtual machine. if no Service Account name is provided, a default one will be created. | `bool` | `false` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the Service Account to bind to the VM. | `string` | `null` | no |
| <a name="input_size"></a> [size](#input\_size) | VM size (small, medium, large) | `string` | `"small"` | no |
| <a name="input_ssh_ca_public_key_uri"></a> [ssh\_ca\_public\_key\_uri](#input\_ssh\_ca\_public\_key\_uri) | URI to the SSH CA public key | `string` | `""` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload type (server, desktop) | `string` | `"server"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_account_binding"></a> [service\_account\_binding](#output\_service\_account\_binding) | Service Account Binding Information |
| <a name="output_vm_credentials"></a> [vm\_credentials](#output\_vm\_credentials) | login credentials |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | Name of the created virtual machine |
| <a name="output_vm_namespace"></a> [vm\_namespace](#output\_vm\_namespace) | Namespace of the created virtual machine |
| <a name="output_vm_resources"></a> [vm\_resources](#output\_vm\_resources) | Configured VM resources |
| <a name="output_vm_service_cluster_ip"></a> [vm\_service\_cluster\_ip](#output\_vm\_service\_cluster\_ip) | Primary ClusterIP of the VM service |
| <a name="output_vm_service_cluster_ips"></a> [vm\_service\_cluster\_ips](#output\_vm\_service\_cluster\_ips) | Primary ClusterIP of the VM service |
| <a name="output_vm_service_hostname"></a> [vm\_service\_hostname](#output\_vm\_service\_hostname) | FQDN of the VM Service |
<!-- END_TF_DOCS -->