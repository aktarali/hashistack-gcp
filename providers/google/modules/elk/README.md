# ELK Terraform module

This is a Terraform module that will provision an ELK (Elasticsearch, Logstash, and Kibana) server on Google cloud.

## Usage

```
module "elk" {
  source = "modules/elk"

  key = "dev"
  private_key = "${file("~/.ssh/id_rsa")}"
}

```

## Author

Module managed by Ali Aktar & Irfan Ansari
Git Repos for https://github.com/aktarali & https://github.com/IrfanAnsari

## License

Apache 2 Licensed. See LICENSE for full details.

