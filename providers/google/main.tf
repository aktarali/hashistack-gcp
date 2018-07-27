provider "google" {
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
  credentials = "${file(pathexpand("~/config/gce-credentials.json"))}"
}

terraform {
  required_version = ">= 0.11.0"
}

data "google_compute_network" "ci-dev-network" {
  name = "default"
}

data "google_compute_subnetwork" "ci-subnetwork" {
  name   = "default"
  region = "${var.gcp_region}"
}

module "vault_cluster" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  #source = "git::git@github.com:hashicorp/terraform-google-vault.git//modules/vault-cluster?ref=v1.0.0"
  source = "modules/vault-cluster"
  network_name = "${data.google_compute_network.ci-dev-network.name}"
  subnetwork_link = "${data.google_compute_subnetwork.ci-subnetwork.self_link}"
  gcp_zone = "${var.gcp_zone}"

  cluster_name = "${var.vault_cluster_name}"
  cluster_size = "${var.vault_cluster_size}"
  cluster_tag_name = "${var.vault_cluster_name}"
  machine_type = "${var.vault_cluster_machine_type}"

  source_image = "${var.vault_source_image}"
  startup_script = "${data.template_file.startup_script_vault.rendered}"

  gcs_bucket_name = "${var.vault_cluster_name}"
  gcs_bucket_location = "${var.gcs_bucket_location}"
  gcs_bucket_storage_class = "${var.gcs_bucket_class}"
  gcs_bucket_force_destroy = "${var.gcs_bucket_force_destroy}"

  # Even when the Vault cluster is pubicly accessible via a Load Balancer, we still make the Vault nodes themselves
  # private to improve the overall security posture. Note that the only way to reach private nodes via SSH is to first
  # SSH into another node that is not private.
  assign_public_ip_addresses = true

  # To enable external access to the Vault Cluster, enter the approved CIDR Blocks or tags below.
  # We enable health checks from the Consul Server cluster to Vault.
  allowed_inbound_cidr_blocks_api = "${var.allowed_inbound_cidr_blocks_api}"
  allowed_inbound_tags_api = ["${var.nomad_client_cluster_name}", "${var.nomad_consul_server_cluster_name}"]
}

# Render the Startup Script that will run on each Vault Instance on boot. This script will configure and start Vault.
data "template_file" "startup_script_vault" {
  template = "${file("${path.module}/examples/root-example/startup-script-vault.sh")}"

  vars {
    consul_cluster_tag_name = "${var.nomad_consul_server_cluster_name}"
    vault_cluster_tag_name = "${var.vault_cluster_name}"
  }
}

module "nomad_and_consul_servers" {
  //source = "git::git@github.com:hashicorp/terraform-google-consul.git//modules/consul-cluster?ref=v0.0.1"
  source = "modules/consul-cluster"
  network_name = "${data.google_compute_network.ci-dev-network.name}"
  subnetwork_link = "${data.google_compute_subnetwork.ci-subnetwork.self_link}"

  gcp_zone = "${var.gcp_zone}"

  cluster_name = "${var.nomad_consul_server_cluster_name}"
  cluster_size = "${var.nomad_consul_server_cluster_size}"
  cluster_tag_name = "${var.nomad_consul_server_cluster_name}"
  machine_type = "${var.nomad_consul_server_cluster_machine_type}"

  source_image = "${var.nomad_consul_server_source_image}"
  startup_script = "${data.template_file.startup_script_nomad_consul_server.rendered}"

  # WARNING!
  # In a production setting, we strongly recommend only launching a Nomad/Consul Server cluster as private nodes.
  # Note that the only way to reach private nodes via SSH is to first SSH into another node that is not private.
  assign_public_ip_addresses = true

  # To enable external access to the Nomad Cluster, enter the approved CIDR Blocks below.
  allowed_inbound_cidr_blocks_http_api = ["${var.allowed_inbound_cidr_blocks_api}"]
  allowed_inbound_cidr_blocks_dns = ["${var.allowed_inbound_cidr_blocks_dns}"]

  # Enable the Nomad clients to reach the Nomad/Consul Server Cluster
  allowed_inbound_tags_http_api = ["${var.nomad_client_cluster_name}","${var.vault_cluster_name}"]
  allowed_inbound_tags_dns = ["${var.nomad_client_cluster_name}","${var.vault_cluster_name}"]
}

module "gce-lb-http" {
  source            = "modules/google-lb-http"
  name              = "doxlon-ci-http-lb"
  target_tags       = ["${module.nomad_client.instance_group_name}"]
  backends          = {
    "0" = [
      { group = "${replace(module.nomad_client.instance_group_url, "Manager", "")}" }
    ],
  }
  backend_params    = [
    # health check path, port name, port number, timeout seconds.
    "/,http,9999,10"
  ]
}


# Enable Firewall Rules to open up Nomad-specific ports
module "nomad_firewall_rules" {
  source = "modules/nomad-firewall-rules"

  gcp_zone = "${var.gcp_zone}"
  cluster_name = "${var.nomad_consul_server_cluster_name}"
  cluster_tag_name = "${var.nomad_consul_server_cluster_name}"

  http_port = 4646
  rpc_port = 4647
  serf_port = 4648

  allowed_inbound_cidr_blocks_http = ["${var.allowed_inbound_cidr_blocks_http}"]
  allowed_inbound_cidr_blocks_rpc = ["${var.allowed_inbound_cidr_blocks_rpc}"]
  allowed_inbound_cidr_blocks_serf = ["${var.allowed_inbound_cidr_blocks_serf}"]
}


# Render the Startup Script that will run on each Nomad Instance on boot. This script will configure and start Nomad.
data "template_file" "startup_script_nomad_consul_server" {
  template = "${file("${path.module}/examples/root-example/startup-script-nomad-consul-server.sh")}"

  vars {
    num_servers                      = "${var.nomad_consul_server_cluster_size}"
    consul_server_cluster_tag_name   = "${var.nomad_consul_server_cluster_name}"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE NOMAD CLIENT NODES
# ---------------------------------------------------------------------------------------------------------------------

module "nomad_client" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git::git@github.com:hashicorp/terraform-google-nomad.git//modules/nomad-cluster?ref=v0.0.1"
  source = "modules/nomad-cluster"
  network_name = "${data.google_compute_network.ci-dev-network.name}"
  subnetwork_link = "${data.google_compute_subnetwork.ci-subnetwork.self_link}"

  gcp_zone = "${var.gcp_zone}"

  cluster_name = "${var.nomad_client_cluster_name}"
  cluster_size = "${var.nomad_client_cluster_size}"
  cluster_tag_name = "${var.nomad_client_cluster_name}"
  machine_type = "${var.nomad_client_machine_type}"

  source_image = "${var.nomad_client_source_image}"
  startup_script = "${data.template_file.startup_script_nomad_client.rendered}"

  # We strongly recommend setting this to "false" in a production setting. Your Nomad cluster has no reason to be
  # publicly accessible! However, for testing and demo purposes, it is more convenient to launch a publicly accessible
  # Nomad cluster.
  assign_public_ip_addresses = true

  # These inbound clients need only receive requests from Nomad Server and Consul
  allowed_inbound_cidr_blocks_http = ["${var.allowed_inbound_cidr_blocks_http}"]
  allowed_inbound_cidr_blocks_rpc = ["${var.allowed_inbound_cidr_blocks_rpc}"]
  allowed_inbound_cidr_blocks_serf = ["${var.allowed_inbound_cidr_blocks_serf}"]

  allowed_inbound_tags_http = ["${var.nomad_consul_server_cluster_name}"]
  allowed_inbound_tags_rpc = ["${var.nomad_consul_server_cluster_name}"]
  allowed_inbound_tags_serf = ["${var.nomad_consul_server_cluster_name}"]
}



# Render the Startup Script that will configure and run both Consul and Nomad in client mode.
data "template_file" "startup_script_nomad_client" {
  template = "${file("${path.module}/examples/root-example/startup-script-nomad-client.sh")}"

  vars {
    consul_server_cluster_tag_name   = "${var.nomad_consul_server_cluster_name}"
  }
}

module "jenkins-ci" {
  source = "modules/jenkins-ci"
  network_name = "${data.google_compute_network.ci-dev-network.name}"
  subnetwork_link = "${data.google_compute_subnetwork.ci-subnetwork.self_link}"

  gcp_zone = "${var.gcp_zone}"

  source_image = "${var.jenkins-ci_source_image}"
  assign_public_ip_addresses = true

  # receive requests from Consul
  allowed_inbound_cidr_blocks_http = ["${var.allowed_inbound_cidr_blocks_http}"]
  allowed_inbound_cidr_blocks_rpc = ["${var.allowed_inbound_cidr_blocks_rpc}"]
  allowed_inbound_cidr_blocks_serf = ["${var.allowed_inbound_cidr_blocks_serf}"]

  allowed_inbound_tags_http = ["${var.nomad_consul_server_cluster_name}"]
  allowed_inbound_tags_rpc = ["${var.nomad_consul_server_cluster_name}"]
  allowed_inbound_tags_serf = ["${var.nomad_consul_server_cluster_name}"]
}
