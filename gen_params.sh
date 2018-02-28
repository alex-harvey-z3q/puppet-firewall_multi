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
define firewall_multi (
  $ensure                = undef,
  $provider              = undef,
EOF

the_big_grep | sed -e 's/^  newp.*(:\([^,)]*\).*/$\1 = undef,/g' | sort | column -t | sed -e 's/^/  /' -e 's/ = /=/'

cat <<'EOF'
) {

  # In order to support Puppet 3.x we must word around
  # https://tickets.puppetlabs.com/browse/PUP-2523.

  # This means we can't pass in $name as part of the hash; it must
  # instead be passed as a separate argument.

  create_resources(firewall, firewall_multi($name, {
    ensure                => $ensure,
    provider              => $provider,
EOF

the_big_grep | sed -e 's/^  newp.*(:\([^,)]*\).*/\1 => $\1,/g' | sort | column -t | sed -e 's/^/    /' -e 's/ => /=>/'

cat <<'EOF'
  }))
}
EOF
