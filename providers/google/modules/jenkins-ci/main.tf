resource "google_compute_firewall" "www" {
  name = "tf-www-firewall"
  network = "default"
  source_tags = ["${var.cluster_tag_name}"]

  allow {
    protocol = "tcp"
    ports = ["8080", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

### To provision Jenkins Master ###

resource "google_compute_instance" "jenkins-master-1" {
  name = "jenkins-master-1"
  machine_type = "f1-micro"
  tags = "${concat(list(var.cluster_tag_name), var.custom_tags)}"
  zone               = "${var.gcp_zone}"

  boot_disk {
    auto_delete = true
    initialize_params {
//      image = "debian-cloud/debian-8"
      image = "${var.source_image}"
      size = "${var.root_volume_disk_size_gb}"
      type = "${var.root_volume_disk_type}"
    }
  }
  network_interface {
    //network = "${var.network_name}"
    subnetwork = "${var.subnetwork_link}"
    access_config {
      # The presence of this property assigns a public IP address to each Compute Instance. We intentionally leave it
      # blank so that an external IP address is selected automatically.
      nat_ip = ""
    }
  }

  # For a full list of oAuth 2.0 Scopes, see https://developers.google.com/identity/protocols/googlescopes
  service_account {
    scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/compute.readonly",
    ]
  }

  metadata_startup_script = <<SCRIPT
apt install -y update
apt install -y docker.io
systemctl enable docker
systemctl start docker
docker pull toanc/jenkins-master:latest
docker run -d -p 8080:8080 -p 50000:50000 --name master-1 toanc/jenkins-master
wget https://raw.githubusercontent.com/eficode/wait-for/master/wait-for -P /tmp
chmod +x /tmp/wait-for
/bin/sh /tmp/wait-for localhost:8080 -t 90
sleep 90
i=`hostname --ip-address`
f=`docker exec -i master-1 bash -c 'java -jar /tmp/jenkins-cli.jar -s http://localhost:8080 -remoting groovy /tmp/findkey --username admin --password admin'`

echo $f > /tmp/checkf
curl -X POST https://api.keyvalue.xyz/[HIDED]/--data ' ip: '$i' secret: '$f' '
SCRIPT

  metadata {
    sshKeys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}