# @summary A defined type wrapper for spawning
#   [puppetlabs/firewall](https://github.com/puppetlabs/puppetlabs-firewall)
#   resources for arrays of certain inputs.
#
# @param [Array] source An array of source IPs or CIDRs.
# @param [Array] destination An array of destination IPs or CIDRs.
# @param [Array] proto An array of protocols.
# @param [Array] icmp An array of ICMP types.
# @param [Array] protocol An array of protocols.
#
define firewall_multi (
  $ensure                      = undef,
  $protocol                    = undef,
) {

  $firewalls = firewall_multi(
    {
      $name => {
        ensure                      => $ensure,
        protocol                    => $protocol,
      }
    }
  )

  create_resources(firewall, $firewalls)
}
