variable "gcp_project" {
  description = "Terraform Admin"
  default = "red-abstraction-182709"

}

variable "gcp_region" {
  default = "europe-west1"
}

variable "allowed_inbound_cidr_blocks_api" {
  description = "The cidr block to allow comms between within your clusters"
  default = "10.132.0.0/20"
}

variable "allowed_inbound_cidr_blocks_dns" {
  description = "The cidr block to allow comms between within your clusters"
  default = "10.132.0.0/20"
}

variable "allowed_inbound_cidr_blocks_http" {
  description = "The cidr block to allow comms between within your clusters"
  default = "10.132.0.0/20"
}

variable "allowed_inbound_cidr_blocks_rpc" {
  description = "The cidr block to allow comms between within your clusters"
  default = "10.132.0.0/20"
}

variable "allowed_inbound_cidr_blocks_serf" {
  description = "The cidr block to allow comms between within your clusters"
  default = "10.132.0.0/20"
}

variable "gcp_zone" {
  description = "Europe West 1b"
  default = "europe-west1-b"
}

variable "vault_cluster_name" {
  description = "The name of the Consul Server cluster. All resources will be namespaced by this value. E.g. consul-server-prod"
  default = "nomad-vault-server-cluster-lb"

}

variable "vault_source_image" {
  description = "The Google Image used to launch each node in the Consul Server cluster. You can build this Google Image yourself at /examples/vault-consul-image."
  default = "nomad-vault-consul-2018-03-19-094706"
}

variable "jenkins-ci_source_image" {
  description = "The Google Image used to launch each node in the Consul Server cluster. You can build this Google Image yourself at /examples/vault-consul-image."
  default = "nomad-vault-consul-2018-03-19-094706"
}

# Nomad Server cluster

variable "nomad_consul_server_cluster_name" {
  description = "The name of the Nomad/Consul Server cluster. All resources will be namespaced by this value. E.g. nomad-server-prod"
  default = "nomad-consul-server-cluster-ci"
}

variable "nomad_consul_server_source_image" {
  description = "The Google Image used to launch each node in the Nomad/Consul Server cluster."
  default = "nomad-vault-consul-2018-03-19-094706"
}

# Nomad Client cluster

variable "nomad_client_cluster_name" {
  description = "The name of the Nomad client cluster. All resources will be namespaced by this value. E.g. consul-server-prod"
  default = "nomad-client-cluster-ci"
}

variable "nomad_client_source_image" {
  description = "The Google Image used to launch each node in the Nomad client cluster."
  default = "nomad-vault-consul-2018-03-19-094706"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

#Vault
variable "vault_cluster_machine_type" {
  description = "The machine type of the Compute Instance to run for each node in the Vault cluster (e.g. n1-standard-1)."
  default = "g1-small"
}

variable "consul_server_machine_type" {
  description = "The machine type of the Compute Instance to run for each node in the Consul Server cluster (e.g. n1-standard-1)."
  default = "g1-small"
}

variable "gcs_bucket_location" {
  description = "The location of the Google Cloud Storage Bucket where Vault secrets will be stored. For details, see https://goo.gl/hk63jH."
  default = "EU"
}

variable "gcs_bucket_class" {
  description = "The Storage Class of the Google Cloud Storage Bucket where Vault secrets will be stored. Must be one of MULTI_REGIONAL, REGIONAL, NEARLINE, or COLDLINE. For details, see https://goo.gl/hk63jH."
  default = "MULTI_REGIONAL"
}

variable "gcs_bucket_force_destroy" {
  description = "If true, Terraform will delete the Google Cloud Storage Bucket even if it's non-empty. WARNING! Never set this to true in a production setting. We only have this option here to facilitate testing."
  default = true
}

variable "vault_cluster_size" {
  description = "The number of nodes to have in the Vault Server cluster. We strongly recommended that you use either 3 or 5."
  default = 5
}

variable "consul_server_cluster_size" {
  description = "The number of nodes to have in the Consul Server cluster. We strongly recommended that you use either 3 or 5."
  default = 5
}

variable "web_proxy_port" {
  description = "The port at which the HTTP proxy server will listen for incoming HTTP requests that will be forwarded to the Vault Health Check URL. We must have an HTTP proxy server to work around the limitation that GCP only permits Health Checks via HTTP, not HTTPS."
  default = "8000"
}

# Nomad Server cluster

variable "nomad_consul_server_cluster_size" {
  description = "The number of nodes to have in the Nomad Server cluster. We strongly recommended that you use either 3 or 5."
  default = 5
}

variable "nomad_consul_server_cluster_machine_type" {
  description = "The machine type of the Compute Instance to run for each node in the Vault cluster (e.g. n1-standard-1)."
  default = "g1-small"
}

# Nomad Client cluster

variable "nomad_client_cluster_size" {
  description = "The number of nodes to have in the Nomad client cluster. This number is arbitrary."
  default = 3
}

variable "nomad_client_machine_type" {
  description = "The machine type of the Compute Instance to run for each node in the Nomad client cluster (e.g. n1-standard-1)."
  default = "g1-small"
}
