# Tailscale Home Lab – Infrastructure as Code

This repository defines the **network access control plane** for my personal home lab using **Tailscale** and **Terraform**.

The objective of this project is to implement a **zero-trust, software-defined network** for home infrastructure that provides secure remote access, clear access boundaries, and reproducible configuration — without exposing inbound ports to the public internet.

---

## High-Level Goals

- Zero inbound port forwarding
- Secure remote access from anywhere
- Infrastructure-as-Code for network policy
- Explicit, auditable access rules (ACLs)
- Separation of gaming, infrastructure, and management traffic

---

## Architecture Overview

This home lab is built around **Tailscale as the networking fabric** and **Terraform as the policy engine**.

### Core Nodes

| Node | Role |
|-----|-----|
| **MagicBox (Windows PC)** | Gaming system running Sunshine for Moonlight streaming |
| **Lenovo Laptop (Proxmox)** | Hosts home services, VMs, and containers |
| **Raspberry Pi 3B+** | DNS (Pi-hole) and secure jump host |
| **Client Devices** | Laptop, phone, or tablet connecting remotely |

All nodes participate in a **Tailscale mesh VPN**.  
Access is governed strictly by **ACLs defined in Terraform**.

---

## Network Model

- No services are exposed directly to the internet
- All access flows through the Tailscale mesh
- ACLs define:
  - Who can connect
  - Which devices are accessible
  - Which ports and protocols are allowed
- Logical trust is enforced **independently of physical LAN placement**

---

## Access Flow Examples

### Gaming (Sunshine / Moonlight)

- Client → Tailscale → MagicBox
- Only required Sunshine ports allowed
- No LAN exposure, no port forwarding

### Infrastructure Access

- Client → Tailscale → Raspberry Pi (Jump Host)
- Pi provides controlled access to internal services
- Lenovo hosts application and monitoring services

### DNS

- Pi provides LAN-wide DNS
- Future integration with Pi-hole for filtering and metrics

---

## Repository Structure

```text
.
├── acl.tf             # Tailscale ACL definitions
├── providers.tf       # Terraform providers
├── variables.tf       # Input variables (no secrets)
├── README.md          # Project documentation
└── .gitignore         # Prevents committing secrets
```

---

## Terrafrom Usage

### Requirements

- Terraform >= 1.5
- Active Tailscale account
- Tailscale API key

```bash
# Initialize
terraform init

# Preview Changes
terraform plan

# Apply Configuration
terraform apply
```

---

## Secrets Management (IMPORTANT)

### ❌ What This Repo Does NOT Do

- Store API keys
- Store credentials
- Encrypt secrets in Git

### ✅ Correct Secrets Handling

Secrets are injected at runtime using environment variables.

```bash
export TAILSCALE_API_KEY="tskey-xxxxxxxx"
```

Terraform provider example:

```hcl
provider "tailscale" {
  api_key = var.tailscale_api_key
}
```

Variable definition:

```hcl
variable "tailscale_api_key" {
  type      = string
  sensitive = true
}
```

---

### Password Manager Integration

Bitwarden is used as the system of record for credentials.

Recommended workflow:

```bash
bw get password tailscale-terraform-api-key
export TAILSCALE_API_KEY=$(bw get password tailscale-terraform-api-key)
```

---

### Security Principles

- Zero-trust networking
- Least-privilege ACLs
- No implicit LAN trust
- No exposed management ports
- Infrastructure configuration is version-controlled

---

## Future Enhancements

Planned extensions to this project include:

- Tailscale device tagging (tag:infra, tag:gaming)
- Service-specific ACL segmentation
- Pi-hole metrics and monitoring
- Prometheus / Grafana ACL integration
- Subnet routing for selected internal services
- Exit node configuration (optional)

---

## Status

This project is actively maintained and evolves alongside the home lab.

The intent is for this repository to remain:

- Public
- Secure
- Reproducible
- Professionally structured

---

## License

This project is provided as-is for educational and personal use.
