output "gcp_project" {
  value = "${var.gcp_project}"
}

output "gcp_zone" {
  value = "${var.gcp_zone}"
}

output "nomad_server_cluster_size" {
  value = "${var.nomad_consul_server_cluster_size}"
}

output "nomad_client_cluster_size" {
  value = "${var.nomad_client_cluster_size}"
}

output "nomad_server_cluster_tag_name" {
  value = "${var.nomad_consul_server_cluster_name}"
}

output "nomad_client_cluster_tag_name" {
  value = "${var.nomad_client_cluster_name}"
}

output "nomad_server_instance_group_id" {
  value = "${module.nomad_and_consul_servers.instance_group_name}"
}

output "nomad_server_instance_group_url" {
  value = "${module.nomad_and_consul_servers.instance_group_url}"
}

output "nomad_client_instance_group_id" {
  value = "${module.nomad_client.instance_group_id}"
}

output "nomad_client_instance_group_url" {
  value = "${module.nomad_client.instance_group_url}"
}

output "vault_cluster_size" {
  value = "${var.vault_cluster_size}"
}

output "cluster_tag_name" {
  value = "${module.vault_cluster.cluster_tag_name}"
}

output "instance_group_id" {
  value = "${module.vault_cluster.instance_group_id}"
}

output "instance_group_url" {
  value = "${module.vault_cluster.instance_group_url}"
}

output "instance_template_url" {
  value = "${module.vault_cluster.instance_template_url}"
}

output "firewall_rule_allow_intracluster_vault_id" {
  value = "${module.vault_cluster.firewall_rule_allow_intracluster_vault_id}"
}

output "firewall_rule_allow_intracluster_vault_url" {
  value = "${module.vault_cluster.firewall_rule_allow_intracluster_vault_url}"
}

output "firewall_rule_allow_inbound_api_id" {
  value = "${module.vault_cluster.firewall_rule_allow_inbound_api_id}"
}

output "firewall_rule_allow_inbound_api_url" {
  value = "${module.vault_cluster.firewall_rule_allow_inbound_api_url}"
}

output "bucket_name_id" {
  value = "${module.vault_cluster.bucket_name_id}"
}

output "bucket_name_url" {
  value = "${module.vault_cluster.bucket_name_url}"
}

output "subnetwork_link" {
  value = "${data.google_compute_subnetwork.ci-subnetwork.self_link}"
}

output "network_name" {
  value = "${data.google_compute_network.ci-dev-network.name}"
}

output "vault_source_image" {
    value = "${var.vault_source_image}"
}

output "allowed_inbound_cidr_blocks_rpc" {
    value = "${var.allowed_inbound_cidr_blocks_rpc}"
}

output "allowed_inbound_cidr_blocks_serf" {
    value = "${var.allowed_inbound_cidr_blocks_serf}"
}

output "allowed_inbound_cidr_blocks_http" {
    value = "${var.allowed_inbound_cidr_blocks_http}"
}

output "allowed_inbound_cidr_blocks_api" {
    value = "${var.allowed_inbound_cidr_blocks_api}"
}

output "allowed_inbound_cidr_blocks_dns" {
  value = "${var.allowed_inbound_cidr_blocks_dns}"
}
