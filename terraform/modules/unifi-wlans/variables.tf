variable "wlans" {
  description = <<-EOT
    WLANs (SSIDs) to create, keyed by a stable identifier. network_id ties the
    SSID to a VLAN; user_group_id references a unifi_user_group. Passphrases
    should come from a SOPS-encrypted source, not plaintext.
  EOT
  type = map(object({
    name            = string
    user_group_id   = string
    network_id      = optional(string)
    ap_group_ids    = optional(set(string))
    security        = optional(string, "wpapsk")
    passphrase      = optional(string)
    wlan_band       = optional(string, "both") # both | 2g | 5g
    is_guest        = optional(bool, false)
    hide_ssid       = optional(bool, false)
    l2_isolation    = optional(bool, false)
    wpa3_support    = optional(bool, false)
    wpa3_transition = optional(bool, false)
    pmf_mode        = optional(string)
  }))
}
