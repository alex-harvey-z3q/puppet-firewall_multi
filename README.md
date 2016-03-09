# firewall_multi

##Overview

The `firewall_multi` module provides a defined type wrapper for spawning [puppetlabs/firewall](https://github.com/puppetlabs/puppetlabs-firewall) resources for arrays of sources and destinations.

##Usage

It is expected that a standard set up for the `firewall` module is followed, in particular with respect to the purging of firewall resources.  If a user of this module, for instance, removes addresses from the array of sources, the corresponding `firewall` resources will only be removed if purging is enabled.  This might be surprising to the user in a way that impacts security.

Otherwise, usage of the `firewall_multi` defined type is the same as with the `firewall` custom type, the only exceptions being that the `source` and `destination` parameters optionally accept arrays of IP addresses or networks, and that a string `from x.x.x.x/x to y.y.y.y/x` is appended to each resource's title to ensure their uniqueness in the catalog.

##Parameters

* `source`: the source IP address or network or an array of sources.  If not specified, a default of `0.0.0.0/0` is used.

* `destination`: the destination IP address or network or an array of destinations.  If not specified, a default of `0.0.0.0/0` is used.

* Any other parameter accepted by `firewall` is also accepted and set for each `firewall` resource created without error-checking.

##Examples

~~~puppet
firewall_multi { '100 allow http and https access':
  source => [
    '10.0.0.10/24',
    '10.0.0.12/24',
    '10.1.1.128',
  ],
  dport  => [80, 443],
  proto  => tcp,
  action => accept,
}
~~~

This will cause three resources to be created:

* `Firewall['100 allow http and https access from 10.0.0.10/24 to 0.0.0.0/0']`
* `Firewall['100 allow http and https access from 10.0.0.12/24 to 0.0.0.0/0']`
* `Firewall['100 allow http and https access from 10.1.1.128 to 0.0.0.0/0']`

##Known Issues

While it is possible to use the `dst_range` parameter, and it will be correctly proxied to the `firewall` resources, the resource will be named `to 0.0.0.0/0` in the catalog, and this name also appears in comments when a system administrator runs `iptables -nL`.  This may be confusing, and it is therefore recommended to instead use an array of destinations, rather than `dst_range`.

At the moment, only the latest version of `puppetlabs/firewall` is supported, namely version `1.8.0`.

##Development

Please read CONTRIBUTING.md before contributing.

###Testing

Make sure you have:

* rake
* bundler

Install the necessary gems:

    bundle install

Note that gems are installed in `.gems` and binaries in `.bin`.  See `.bundle/config`.

To run the tests from the root of the source code:

    bundle exec rake spec
