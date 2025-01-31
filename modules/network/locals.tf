# =============================================================================
# Network Locals
# =============================================================================

locals {
  # Common prefixes and tags
  firewall_prefix = "pexip-infinity"
  tags = {
    management  = "pexip-mgmt"
    transcoding = "pexip-transcoding"
    proxy       = "pexip-proxy"
  }

  # Default ranges for media/signaling traffic
  default_ranges = ["0.0.0.0/0"] # Used for SIP, H.323, Teams, and GMeet traffic

  # Port configurations by service type
  ports = {
    # Management access (inbound only, uses management_access.cidr_ranges)
    management = {
      admin = {
        description = "Management node administrative access"
        tcp         = ["443"]
      }
      ssh = {
        description = "Management node and conferencing nodes SSH access"
        tcp         = ["22"]
      }
      conf_provisioning = {
        description = "Conferencing node provisioning"
        tcp         = ["8443"]
      }
    }

    # Call services (inbound/outbound, uses default_ranges for media/signaling)
    conferencing = {
      sip = {
        description = "SIP signaling"
        tcp         = ["5060", "5061"] # SIP and SIP/TLS
        udp         = ["40000-49999"]  # SIP UDP media
      }
      h323 = {
        description = "H.323 signaling"
        tcp         = ["1720", "33000-39999"] # H.323/H.245
        udp         = ["1719"]                # H.323 RAS
      }
      teams = {
        description = "Microsoft Teams integration"
        tcp         = ["443"]         # Teams signaling
        udp         = ["50000-54999"] # Teams media
      }
      gmeet = {
        description = "Google Meet integration"
        tcp         = ["443"]         # Meet signaling
        udp         = ["19302-19309"] # SRTP/SRTCP
      }
    }

    # Internal communication between nodes
    internal = {
      description = "Internal communication between nodes"
      udp         = ["500"] # ISAKMP (IPsec)
      protocols   = ["esp"] # ESP (IP Protocol 50)
    }

    # =============================================================================
    # NOT USED, BUT LEFT IN FOR REFERENCE AND OPTIONAL USE
    # =============================================================================

    # GCP allows all traffic outbound by default.
    # Core services (outbound only, always enabled.) Not used, but left in for reference or optional use.
    core = {
      dns = {
        description = "DNS queries"
        tcp         = ["53"]
        udp         = ["53"]
      }
      ntp = {
        description = "NTP time sync"
        udp         = ["123"]
      }
    }

    # Optional services (outbound only, always enabled) Not used, but left in for reference or optional use.
    optional = {
      teams_hub = {
        description = "Teams Connector Azure Event Hub (AMQPS)"
        tcp         = ["5671"]
      }
      syslog = {
        description = "Syslog messages"
        udp         = ["514"]
      }
      smtp = {
        description = "SMTP mail"
        tcp         = ["587"]
      }
      ldap = {
        description = "LDAP directory services"
        tcp         = ["389", "636"] # LDAP and LDAPS
      }
    }
  }
}
