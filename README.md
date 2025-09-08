# terraform-openshift-vm

A Terraform workspace for creating simple, repeatable virtual machines either **inside Red Hat OpenShift (via OpenShift Virtualization/KubeVirt)** or on **VMware vSphere**, with optional integrations for **HCP Vault** and **HCP Boundary** to provision secrets and secure remote access.

> **Status:** WIP / personal lab. Contributions and PRs welcome.

---

## Features

* Create a Linux VM on **OpenShift Virtualization (KubeVirt)** *or* on **vSphere**
* Parameterized CPU/RAM/disk, image/source, network, storage class, and metadata
* Optional bootstrap scripts (cloud-init/ignition-style user data)
* Optional HashiCorp integrations:

  * **HCP Vault** – seed paths/policies or pull dynamic secrets at deploy time
  * **HCP Boundary** – register targets/workers for secure access

---

## Repository layout

```
.
├── main.tf                # Composes modules / selects a scenario
├── variables.tf           # Input variables (shared & per-scenario)
├── outputs.tf             # Useful outputs (VM name/IP/URLs, etc.)
├── terraform-vcenter-vm/  # vSphere VM scenario (vsphere provider)
├── terraform-kubernetes-openshift-virtual-machine-rhel/  # OpenShift VM (kubevirt)
├── terraform-hcp-vault/   # (Optional) HCP Vault wiring
└── terraform-hcp-boundary/            # (Optional) HCP Boundary wiring
    └── terraform-hcp-boundary-k8s-worker/ # (Optional) Boundary worker for K8s/OCP
```

Each subfolder is a standalone module/scenario. `main.tf` can be used to thin‑wrap a chosen scenario, or run the scenario modules directly from their directories.

---

## Prerequisites

* **Terraform** ≥ 1.5
* For **OpenShift VM** scenario

  * An OpenShift 4.x cluster with **OpenShift Virtualization** enabled (KubeVirt)
  * `oc` CLI authenticated against the cluster
  * A StorageClass with RWX/RWO as needed
  * A VM source: container disk image (e.g., registry) or HTTP image/DS
* For **vSphere VM** scenario

  * vCenter URL, user, and credentials with permissions to create VMs
  * Existing datastore, cluster, network/portgroup, and template or ISO
* Optional integrations

  * **HCP Vault** project & cluster (plus auth method/token)
  * **HCP Boundary** org/project and worker credentials

> ⚠️ Security: These examples are lab‑oriented. Hardening, network policies, and secret handling are your responsibility in production.

---

## Quick start

### 1) Clone & select a scenario

```bash
git clone https://github.com/GuyBarros/terraform-openshift-vm.git
cd terraform-openshift-vm
```

You can:

* Use the top‑level `main.tf` with variables to pick a scenario, **or**
* `cd` into a scenario folder and run it standalone.

### 2) Configure variables

Create a `terraform.tfvars` (or use environment variables) with the inputs you need. See the **Variables** section below for the common inputs and scenario‑specific settings.

### 3) Plan & apply

```bash
terraform init
terraform plan
terraform apply
```

When done:

```bash
terraform destroy
```

---

## Variables (overview)

> See `variables.tf` for authoritative names and defaults. Below is a convenient summary of common inputs you’ll likely set.

### Common

| Variable               | Type        | Description                                         |
| ---------------------- | ----------- | --------------------------------------------------- |
| `name`                 | string      | VM name/prefix.                                     |
| `labels`               | map(string) | Metadata/labels to add to the VM.                   |
| `cpu`                  | number      | vCPUs.                                              |
| `memory`               | string      | RAM (e.g., `4Gi`).                                  |
| `disk_size`            | string      | Root disk size (e.g., `30Gi`).                      |
| `cloud_init_user_data` | string      | User data for cloud‑init to bootstrap the instance. |

### OpenShift Virtualization (KubeVirt)

| Variable                | Type   | Description                                         |
| ----------------------- | ------ | --------------------------------------------------- |
| `namespace`             | string | Project/namespace to create the VM in.              |
| `storage_class`         | string | StorageClass for PVCs/volumes.                      |
| `network_attachment`    | string | (Optional) Multus NetworkAttachmentDefinition name. |
| `source_container_disk` | string | Optional container image (e.g., `quay.io/...`).     |
| `source_url`            | string | Optional HTTP(S) URL to a QCOW2/RAW image.          |

### vSphere

| Variable                            | Type   | Description                                      |
| ----------------------------------- | ------ | ------------------------------------------------ |
| `vsphere_server`                    | string | vCenter hostname or IP.                          |
| `vsphere_user` / `vsphere_password` | string | Credentials. Prefer using environment variables. |
| `datacenter`                        | string | Target datacenter.                               |
| `cluster`                           | string | Target cluster/ESXi cluster.                     |
| `datastore`                         | string | Datastore for VM disks.                          |
| `network`                           | string | Portgroup/network name.                          |
| `template`                          | string | VM template to clone (recommended) or ISO path.  |
| `guest_customization`               | object | Guest customization spec (hostname, NICs, etc.). |

### HCP Vault (optional)

| Variable               | Type         | Description                                           |
| ---------------------- | ------------ | ----------------------------------------------------- |
| `hcp_vault_project_id` | string       | HCP project id.                                       |
| `vault_addr`           | string       | Vault address/cluster URL.                            |
| `vault_token`          | string       | Token or auth method (AppRole/JWT/OIDC).              |
| `vault_kv_paths`       | list(string) | Paths to read at deploy time (e.g., `kv/app/config`). |

### HCP Boundary (optional)

| Variable                  | Type   | Description                            |
| ------------------------- | ------ | -------------------------------------- |
| `boundary_addr`           | string | Boundary URL.                          |
| `boundary_auth_method_id` | string | Auth method id for automation.         |
| `register_as_target`      | bool   | Whether to create a target for the VM. |
| `k8s_worker_enabled`      | bool   | Deploy a Boundary worker in K8s/OCP.   |

---

## Outputs

Exact outputs depend on the scenario, but typically include:

* VM name and namespace (OCP) or VM moref/path (vSphere)
* Primary IP (if detectable)
* Helpful URLs (OpenShift console, VNC/serial, etc.)

> See `outputs.tf` for the full list.

---

## Example: OpenShift RHEL VM

```hcl
module "rhel_vm" {
  source               = "./terraform-kubernetes-openshift-virtual-machine-rhel"

  name                 = "rhel-demo"
  namespace            = "vms"
  cpu                  = 2
  memory               = "4Gi"
  disk_size            = "30Gi"
  storage_class        = "ocs-storagecluster-ceph-rbd"

  # Choose one source
  # source_container_disk = "quay.io/containerdisks/rhel8:latest"
  # or
  # source_url = "https://myrepo.local/images/rhel8.qcow2"

  cloud_init_user_data = <<-EOT
  #cloud-config
  users:
    - name: core
      ssh-authorized-keys:
        - ssh-rsa AAAA...yourkey
  runcmd:
    - [ sh, -c, "echo hello from cloud-init" ]
  EOT
}
```

---

## Example: vSphere VM from template

```hcl
module "vsphere_vm" {
  source          = "./terraform-vcenter-vm"

  name            = "rhel-vm"
  cpu             = 2
  memory          = "4096"
  disk_size       = "30Gi"

  vsphere_server  = var.vsphere_server
  vsphere_user    = var.vsphere_user
  vsphere_password= var.vsphere_password
  datacenter      = "DC01"
  cluster         = "CL01"
  datastore       = "DS01"
  network         = "VM Network"
  template        = "rhel9-template"

  guest_customization = {
    hostname = "rhel-vm"
    domain   = "lab.local"
  }
}
```

---

## Optional: Wire up HCP Vault + Boundary

You can chain the optional modules to fetch secrets during deployment (e.g., injecting SSH keys or app secrets) and to create a Boundary target for just‑in‑time access.

```hcl
module "hcp_vault" {
  source      = "./terraform-hcp-vault"
  vault_addr  = var.vault_addr
  vault_token = var.vault_token
  kv_paths    = ["kv/app/config", "kv/ssh"]
}

module "hcp_boundary" {
  source                  = "./terraform-hcp-boundary"
  boundary_addr           = var.boundary_addr
  boundary_auth_method_id = var.boundary_auth_method_id
  register_as_target      = true
}
```

---

## Workflow tips

* Prefer **templates** over ISOs for vSphere (faster and more reliable)
* For OpenShift, validate StorageClass access modes and PVC binding
* Keep user data small and idempotent; use a post‑provisioner config management tool for complex bootstrap
* Store credentials in your secret manager (Vault), not in `*.tfvars`

---

## Troubleshooting

* **PVC pending / VM stuck** (OCP): check StorageClass and quota. Verify `source_url` or container disk image exists and is reachable.
* **No IP output**: guest tools/agents may be required; otherwise fetch IP from DHCP server or console.
* **vSphere auth errors**: confirm your user can create VMs/templates on the target cluster/datastore.
* **Boundary target unreachable**: open egress to Boundary controllers and verify worker registration.

---

## Roadmap / Ideas

* Windows VM example for OCP + vSphere
* Additional networks via Multus
* Image upload helpers (DataVolume/PVC from URL)
* Example GitHub Actions workflow

---

## Contributing

PRs are welcome. Please:

1. Open an issue describing the change and scenario
2. Keep examples cloud‑agnostic where possible
3. Include `terraform fmt` & `terraform validate`

---

## License

[Apache 2.0](./LICENSE)
