output "cluster_tag_name" {
  value = "${var.cluster_name}"
}

output "instance_group_id" {
  value = "${google_compute_instance_group_manager.vault.id}"
}

output "instance_group_url" {
  value = "${google_compute_instance_group_manager.vault.self_link}"
}

output "instance_template_url" {
  value = "${data.template_file.compute_instance_template_self_link.rendered}"
}

output "firewall_rule_allow_intracluster_vault_url" {
  value = "${google_compute_firewall.allow_intracluster_vault.self_link}"
}

output "firewall_rule_allow_intracluster_vault_id" {
  value = "${google_compute_firewall.allow_intracluster_vault.id}"
}

output "firewall_rule_allow_inbound_api_url" {
  value = "${google_compute_firewall.allow_inboud_api.*.self_link}"
}

output "firewall_rule_allow_inbound_api_id" {
  value = "${google_compute_firewall.allow_inboud_api.*.id}"
}

output "bucket_name_url" {
  value = "${google_storage_bucket.vault_storage_backend_le.*.self_link}"
}

output "bucket_name_id" {
  value = "${google_storage_bucket.vault_storage_backend_le.*.id}"
}

output "subnetwork_link" {
  value = "${var.subnetwork_link}"
}

output "allowed_inbound_cidr_blocks_api" {
  value = ["${var.allowed_inbound_cidr_blocks_api}"]
}


