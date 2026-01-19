resource "tailscale_acl" "main" {
  acl = jsonencode({

    # ======================
    # IDENTITY MODEL
    # ======================
    groups = {
      "group:clients" = ["sharlynemadrigal@gmail.com"]
    }

    tagOwners = {
      "tag:infra"       = ["autogroup:admin"]
      "tag:jump"        = ["autogroup:admin"]
      "tag:workstation" = ["autogroup:admin"]
      #"tag:web"         = ["autogroup:admin"]
      #"tag:controller"  = ["autogroup:admin"]
      #"tag:security"    = ["autogroup:admin"]
    }

    # ======================
    # NETWORK ACLs
    # ======================
    acls = [

      # Admin full access
      {
        action = "accept"
        src    = ["autogroup:admin"]
        dst = [
          "tag:infra:*",
          "tag:jump:*",
          "tag:workstation:*"
          #"tag:web:*",
          #"tag:controller:*",
          #"tag:security:*"
        ]
      },

      # Jump host → Infra
      {
        action = "accept"
        src    = ["tag:jump"]
        dst    = ["tag:infra:22"]
      },

      # Workstation → Jump
      {
        action = "accept"
        src    = ["tag:workstation"]
        dst    = ["tag:jump:22"]
      },

      # Workstation → Infra
      {
        action = "accept"
        src    = ["tag:workstation"]
        dst    = ["tag:infra:22", "tag:infra:8443"]
      },

      # Sunshine / Moonlight remote access
      {
        action = "accept"
        src    = ["tag:workstation"]
        dst    = ["tag:workstation:47984", "tag:workstation:47989"]
      },

      # Clients → Infra
      {
        action = "accept"
        src    = ["group:clients"]
        dst    = ["tag:infra:*"]
      }
    ]

    # ======================
    # TAILSCALE SSH RULES
    # ======================
    ssh = [

      # Workstation → Jump
      {
        action = "accept"
        src    = ["tag:workstation"]
        dst    = ["tag:jump"]
        users  = ["ansible", "rg", "rickg"]
      },

      # Workstation → Infra
      {
        action = "accept"
        src    = ["tag:workstation"]
        dst    = ["tag:infra"]
        users  = ["ansible", "rg", "rickg"]
      },

      # Jump → Infra
      {
        action = "accept"
        src    = ["tag:jump"]
        dst    = ["tag:infra"]
        users  = ["rickg"]
      }
    ]

    # ======================
    # DEVICE POSTURE
    # ======================
    defaultSrcPosture = ["posture:anyMac"]

    postures = {
      "posture:anyMac" = [
        "node:os == 'macos'",
        "node:tsReleaseTrack == 'stable'"
      ]
    }
  })
}
