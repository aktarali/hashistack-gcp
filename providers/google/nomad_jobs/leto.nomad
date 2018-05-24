job "leto" {
  datacenters = ["europe-west1-b"]
  type        = "service"
  group "leto" {
    count = 3
    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }
    task "docker" {
      driver = "docker"
      config {
        image = "gcr.io/legal-entity-ci/leto:latest"
        port_map {
          web = "80"
        }
      }
      resources {
        cpu    = 50
        memory = 32
        network {
          mbits = 1
          port  "web" 
            {
            }
        }
      }
      service {
        name = "leto"
        port = "web"

        tags = ["urlprefix-/"]

        check {
          type     = "http"
          path     = "/#/not-authorized"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}

