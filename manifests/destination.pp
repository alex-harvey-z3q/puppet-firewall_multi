define firewall_multi::destination (
  $action,
  $dport,
  $proto,
) {

  # $name contains something like 'description__1.1.1.1/24__2.2.2.2/24'
  $_name = regsubst(regsubst($name, '__', ' from '), '__', ' to ')
  $array = split($name, '__')
  firewall { $_name:
    action => $action,
    dport  => $dport,
    proto  => $proto,
    source      => $array[1],
    destination => $array[2],
  }
}
