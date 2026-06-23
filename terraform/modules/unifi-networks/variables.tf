variable "networks" {
  description = <<-EOT
    UniFi corporate networks (VLANs) to create, keyed by a stable identifier.
    DHCP name servers come from dhcp.dns. mDNS reflection, inter-VLAN isolation
    and internet access are managed here. IPv6 is disabled by default.
  EOT
  type = map(object({
    name    = string
    vlan_id = number
    subnet  = string # gateway IP + prefix, e.g. 10.0.20.1/24
    purpose = optional(string, "corporate")
    dhcp = optional(object({
      start = string
      stop  = string
      dns   = optional(list(string)) # DNS servers handed to clients
      lease = optional(number)       # seconds
    }))
    multicast_dns     = optional(bool, false) # mDNS reflection onto this VLAN
    network_isolation = optional(bool, false) # block intra-VLAN client traffic
    internet_access   = optional(bool, true)
    ipv6_disabled     = optional(bool, true)
  }))
}
