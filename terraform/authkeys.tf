# Windows Sunshine / Jump Host
resource "tailscale_tailnet_key" "magicbox" {
  reusable      = false
  ephemeral     = false
  preauthorized = true
  tags          = ["tag:jump", "tag:workstation"]
  expiry        = 3600
}

# Pi3 – DNS, Exit Node, Infra
resource "tailscale_tailnet_key" "pi3" {
  reusable      = false
  ephemeral     = false
  preauthorized = true
  tags          = ["tag:infra"]
  expiry        = 3600
}

# VM Controller
# resource "tailscale_tailnet_key" "vm_controller" {
#   reusable      = false
#   ephemeral     = false
#   preauthorized = true
#   tags          = ["tag:controller"]
#   expiry        = 3600
# }

# VM Security
# resource "tailscale_tailnet_key" "vm_security" {
#   reusable      = false
#   ephemeral     = false
#   preauthorized = true
#   tags          = ["tag:security"]
#   expiry        = 3600
# }

# VM Web App
# resource "tailscale_tailnet_key" "vm_web" {
#   reusable      = false
#   ephemeral     = false
#   preauthorized = true
#   tags          = ["tag:web"]
#   expiry        = 3600
# }
