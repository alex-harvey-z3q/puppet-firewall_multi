# To auto-generate the list of parameters accepted by the defined type:

usage() {
  echo "Usage: bash $0 > manifests/init.pp"
  exit
}

[ "$1" == -h ] && usage

path_to_firewall=../puppetlabs-firewall

the_big_grep() {
  egrep '^  new(property|param)\(:' ${path_to_firewall}/lib/puppet/type/firewall.rb | grep -v '(:name)'
}

cat <<'EOF'
# @summary A defined type wrapper for spawning
#   [puppetlabs/firewall](https://github.com/puppetlabs/puppetlabs-firewall)
#   resources for arrays of certain inputs.
#
# @param [Array] source An array of source IPs or CIDRs.
# @param [Array] destination An array of destination IPs or CIDRs.
# @param [Array] proto An array of protocols.
# @param [Array] icmp An array of ICMP types.
# @param [Array] provider An array of providers.
#
define firewall_multi (
  $ensure                      = undef,
  $provider                    = undef,
EOF

the_big_grep | sed -e 's/^  newp.*(:\([^,)]*\).*/$\1 = undef,/g' | sort | column -t | sed -e 's/^/  /' -e 's/ = /=/'

cat <<'EOF'
) {

  $firewalls = firewall_multi(
    {
      $name => {
        ensure                      => $ensure,
        provider                    => $provider,
EOF

the_big_grep | sed -e 's/^  newp.*(:\([^,)]*\).*/\1 => $\1,/g' | sort | column -t | sed -e 's/^/        /' -e 's/ => /=>/'

cat <<'EOF'
      }
    }
  )

  create_resources(firewall, $firewalls)
}
EOF
