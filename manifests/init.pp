define firewall_multi (
  $action = undef,
  $dport  = undef,
  $proto  = undef,
  $source = undef,
  $destination = undef,
) {

  if $name =~ /__/ {
    fail("a firewall_multi resource may not contain the string '__'")
  }

  # Welcome to nested loops in Puppet 3 and earlier.
  # We spawn an array of firewall::source resources for each $source.
  # We pass the array $destination in too, where a corresponding array of firewall::destination resources will be spawned.
  # We pass the source in via the $name to ensure uniqueness of firewall_multi::source resources.

  # NOTE: The regsubst function accepts and returns either a string or array of strings.
  $_source = regsubst($source, '(.*)', "${name}__\\1")

  firewall_multi::source { $_source:
    action => $action,
    dport  => $dport,
    proto  => $proto,
    destination => $destination,
  }

}
