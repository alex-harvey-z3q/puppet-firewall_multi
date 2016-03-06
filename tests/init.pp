# declare a resource
firewall_multi { '00100 accept on port 80':
  action => 'accept',
  dport  => 80,
  proto  => 'tcp',
  source => [
    '1.1.1.1/24',
    '2.2.2.2/24',
  ],
  destination => [
    '3.3.3.3/24',
    '4.4.4.4/24',
  ],
}
