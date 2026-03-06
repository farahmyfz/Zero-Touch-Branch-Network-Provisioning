terraform {
  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = "1.19.0"   
    }
  }
}

provider "routeros" {
  hosturl  = "api://192.168.10.1:8728"
  username = "admin"
  password = "admin"
  insecure = true
}

provider "routeros" {
  alias    = "r2"
  hosturl  = "api://192.168.20.1:8728"
  username = "auto"
  password = "admin"
  insecure = true
}


resource "routeros_system_identity" "r1_name" {
  name = "R1-TERRAFORM"
}

resource "routeros_system_identity" "r2_name" {
  provider = routeros.r2
  name     = "R2-TERRAFORM"
}

resource "routeros_ip_address" "ip_lan" {
  address   = "172.16.1.1/24"
  interface = "ether4"
}

# R1 → Route ke LAN R2
resource "routeros_ip_route" "route_to_r2" {
  dst_address = "192.168.20.0/24"
  gateway     = "10.10.10.2"
  distance    = 1
}

# R2 → Route ke LAN R1
resource "routeros_ip_route" "route_to_r1" {
  provider    = routeros.r2
  dst_address = "192.168.10.0/24"
  gateway     = "10.10.10.1"
  distance    = 1
}