job "fabio" {
  datacenters = ["europe-west1-b"]
  type = "system"
  update {
    stagger = "5s"
    max_parallel = 1
  }
  group "fabio" {
    task "fabio" {
      driver = "exec"
      config {
        command = "fabio-1.5.6-go1.9.2-linux_amd64"
        args = [
          "-proxy.localip", "0.0.0.0"
        ]
      }
      artifact {
        source = "https://github.com/fabiolb/fabio/releases/download/v1.5.6/fabio-1.5.6-go1.9.2-linux_amd64"
      }
      resources {
        cpu = 500
        memory = 128
        network {
          mbits = 1
          port "http" {
            static = 9999
          }
          port "ui" {
            static = 9998
          }
        }
      }
    }
  }
}