# To auto-generate the list of parameters accepted by the defined type:

cat <<'EOF'
define firewall_multi (
  $ensure                = undef,
  $provider              = undef,
EOF
egrep '^  new(property|param)\(:' ../puppetlabs-firewall/lib/puppet/type/firewall.rb | grep -v '(:name)' | sed -e 's/^  newp.*(:\([^,)]*\).*/$\1 = undef,/g' | sort | column -t | sed -e 's/^/  /' -e 's/ = /=/'
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
egrep '^  new(property|param)\(:' ../puppetlabs-firewall/lib/puppet/type/firewall.rb | grep -v '(:name)' | sed -e 's/^  newp.*(:\([^,)]*\).*/\1 => $\1,/g'   | sort | column -t | sed -e 's/^/    /' -e 's/ => /=>/'
cat <<'EOF'
  }))
}
EOF
