# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "kubernetes_config_map" "boundary-worker" {
  depends_on = [boundary_worker.controller_led]
  metadata {
    name      = "boundary-worker-config"
    namespace = var.landing_zone_name
  }

  data = {
    "config.hcl" = <<EOF
disable_mlock = true

log_level = "debug"

hcp_boundary_cluster_id = "${var.hcp_boundary_cluster_id}"

worker {
    auth_storage_path = "/opt/boundary/data"
	tags {
    type = ["${var.landing_zone_name}"]
  }
  controller_generated_activation_token = "${boundary_worker.controller_led.controller_generated_activation_token}"
}


listener "tcp" {
	address = "0.0.0.0:9202"
	purpose = "proxy"
}

listener "tcp" {
	address = "0.0.0.0:9203"
	purpose = "ops"
	tls_disable = true
}

EOF
  }
}
