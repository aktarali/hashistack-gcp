job "docs" {
  datacenters = ["europe-west1-b"]

  group "example" {
    task "server" {
      driver = "docker"

      config {
        image = "hashicorp/http-echo"
        args = [
          "-listen", ":5678",
          "-text", "hello world",
        ]
      }

      resources {
        network {
          mbits = 10
          port "http" {
            static = "5678"
          }
        }
      }
      service {
        name = "example"
        port = "http"
        tags = ["urlprefix-/echo"]
        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
