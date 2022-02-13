terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

variable "do_token" {
  description = "DigitalOcean API token"
  type = string
  sensitive = true
}

variable "cf_key" {
  description = "CloudFlare API key"
  type = string
  sensitive = true
}

variable "cf_email" {}
variable "cf_zone_id" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Configure the CloudFlare Provider
provider "cloudflare" {
  email   = var.cf_email
  api_key = var.cf_key
}

# Create a web server
resource "digitalocean_droplet" "blakerenton-net" {
  image       = "ubuntu-21-10-x64"
  name        = "blakerenton-net"
  region      = "nyc1"
  size        = "s-1vcpu-1gb"
  monitoring  = true
  ssh_keys    = [ "75:1c:b4:af:e1:70:dc:25:1c:93:0a:7f:e7:ba:70:7c" ]
}

# Create a CloudFlare record
resource "cloudflare_record" "blakerenton-net-a" {
  zone_id = var.cf_zone_id
  name    = "blakerenton.net"
  value   =  digitalocean_droplet.blakerenton-net.ipv4_address
  type    = "A"
  ttl     = 1 # auto
  proxied = true
}

resource "cloudflare_record" "blakerenton-net-www" {
  zone_id = var.cf_zone_id
  name    = "www"
  value   = "blakerenton.net"
  type    = "CNAME"
  ttl     = 1 # auto
  proxied = true
}

resource "cloudflare_record" "blakerenton-net-traefik" {
  zone_id = var.cf_zone_id
  name    = "traefik"
  value   = "blakerenton.net"
  type    = "CNAME"
  ttl     = 1 # auto
  proxied = true
}

resource "cloudflare_record" "blakerenton-net-status" {
  zone_id = var.cf_zone_id
  name    = "status"
  value   = "blakerenton.net"
  type    = "CNAME"
  ttl     = 1 # auto
  proxied = true
}

# Output the IP address
output "droplet_ipv4_address" {
  value = digitalocean_droplet.blakerenton-net.ipv4_address
}
