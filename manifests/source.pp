define firewall_multi::source (
  $action,
  $dport,
  $proto,
  $destination,
) {

  # $name contains something like 'description__1.1.1.1/24'
  # The regsubst built-in function accepts and returns either a string or array of strings.
  $_destination = regsubst($destination, '(.*)', "${name}__\\1")
  firewall_multi::destination { $_destination:
    action => $action,
    dport  => $dport,
    proto  => $proto,
  }
}
