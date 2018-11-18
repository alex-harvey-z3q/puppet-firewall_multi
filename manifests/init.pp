# @summary A defined type wrapper for spawning
#   [puppetlabs/firewall](https://github.com/puppetlabs/puppetlabs-firewall)
#   resources for arrays of certain inputs.
#
# @param [Array] source An array of source IPs or CIDRs.
# @example Array of sources
#
#   firewall_multi { '100 allow http and https access':
#     source => [
#       '10.0.10.0/24',
#       '10.0.12.0/24',
#       '10.1.1.128',
#     ],
#     dport  => [80, 443],
#     proto  => tcp,
#     action => accept,
#   }
#
#   This will cause three resources to be created:
#
#   * Firewall['100 allow http and https access from 10.0.10.0/24']
#   * Firewall['100 allow http and https access from 10.0.12.0/24']
#   * Firewall['100 allow http and https access from 10.1.1.128']
#
# @param [Array] destination An array of destination IPs or CIDRs.
# @example Arrays of sources and destinations
#
#   firewall_multi { '100 allow http and https access':
#     source => [
#       '10.0.10.0/24',
#       '10.0.12.0/24',
#     ],
#     destination => [
#       '10.2.0.0/24',
#       '10.3.0.0/24',
#     ],
#     dport  => [80, 443],
#     proto  => tcp,
#     action => accept,
#   }
#
#   This will cause four resources to be created:
#
#   * Firewall['100 allow http and https access from 10.0.10.0/24 to 10.2.0.0/24']
#   * Firewall['100 allow http and https access from 10.0.10.0/24 to 10.3.0.0/24']
#   * Firewall['100 allow http and https access from 10.0.12.0/24 to 10.2.0.0/24']
#   * Firewall['100 allow http and https access from 10.0.12.0/24 to 10.3.0.0/24']
#
# @param [Array] proto An array of protocols.
# @example Array of protocols
#
#   firewall_multi { '100 allow DNS lookups':
#     dport  => 53,
#     proto  => ['tcp', 'udp'],
#     action => 'accept',
#   }
#
#   This will cause two resources to be created:
#
#   * Firewall['100 allow DNS lookups protocol tcp']
#   * Firewall['100 allow DNS lookups protocol udp']
#
# @param [Array] icmp An array of ICMP types.
# @example Array of ICMP types
#
#   firewall_multi { '100 accept icmp output':
#     chain  => 'OUTPUT',
#     proto  => 'icmp',
#     action => 'accept',
#     icmp   => [0, 8],
#   }
#
#   This will cause two resources to be created:
#
#   * Firewall['100 accept icmp output icmp type 0']
#   * Firewall['100 accept icmp output icmp type 8']
#
# @param [Array] provider An array of providers.
# @example Array of providers
#
#   Open a firewall for IPv4 and IPv6 on a web server:
#
#   firewall_multi { '100 allow http and https access':
#     dport    => [80, 443],
#     proto    => 'tcp',
#     action   => 'accept',
#     provider => ['ip6tables', 'iptables'],
#   }
#
#   This will cause two resources to be created:
#
#   * Firewall['100 allow http and https access using provider ip6tables']
#   * Firewall['100 allow http and https access using provider iptables']
#
# @example Used in place of a single firewall resource
#
#   If none of firewall_multi's array functionality is used, then the firewall_multi and firewall resources can be used interchangeably.
#
define firewall_multi (
  $ensure                = undef,
  $provider              = undef,
  $action                      = undef,
  $burst                       = undef,
  $chain                       = undef,
  $checksum_fill               = undef,
  $clamp_mss_to_pmtu           = undef,
  $clusterip_clustermac        = undef,
  $clusterip_hash_init         = undef,
  $clusterip_hashmode          = undef,
  $clusterip_local_node        = undef,
  $clusterip_new               = undef,
  $clusterip_total_nodes       = undef,
  $connlimit_above             = undef,
  $connlimit_mask              = undef,
  $connmark                    = undef,
  $ctstate                     = undef,
  $date_start                  = undef,
  $date_stop                   = undef,
  $destination                 = undef,
  $dport                       = undef,
  $dst_cc                      = undef,
  $dst_range                   = undef,
  $dst_type                    = undef,
  $gateway                     = undef,
  $gid                         = undef,
  $goto                        = undef,
  $hashlimit_above             = undef,
  $hashlimit_burst             = undef,
  $hashlimit_dstmask           = undef,
  $hashlimit_htable_expire     = undef,
  $hashlimit_htable_gcinterval = undef,
  $hashlimit_htable_max        = undef,
  $hashlimit_htable_size       = undef,
  $hashlimit_mode              = undef,
  $hashlimit_name              = undef,
  $hashlimit_srcmask           = undef,
  $hashlimit_upto              = undef,
  $hop_limit                   = undef,
  $icmp                        = undef,
  $iniface                     = undef,
  $ipsec_dir                   = undef,
  $ipsec_policy                = undef,
  $ipset                       = undef,
  $isfirstfrag                 = undef,
  $isfragment                  = undef,
  $ishasmorefrags              = undef,
  $islastfrag                  = undef,
  $jump                        = undef,
  $kernel_timezone             = undef,
  $length                      = undef,
  $limit                       = undef,
  $line                        = undef,
  $log_level                   = undef,
  $log_prefix                  = undef,
  $log_uid                     = undef,
  $mac_source                  = undef,
  $mask                        = undef,
  $match_mark                  = undef,
  $month_days                  = undef,
  $mss                         = undef,
  $nflog_group                 = undef,
  $nflog_prefix                = undef,
  $nflog_range                 = undef,
  $nflog_threshold             = undef,
  $outiface                    = undef,
  $physdev_in                  = undef,
  $physdev_is_bridged          = undef,
  $physdev_is_in               = undef,
  $physdev_is_out              = undef,
  $physdev_out                 = undef,
  $pkttype                     = undef,
  $port                        = undef,
  $proto                       = undef,
  $queue_bypass                = undef,
  $queue_num                   = undef,
  $random                      = undef,
  $rdest                       = undef,
  $reap                        = undef,
  $recent                      = undef,
  $reject                      = undef,
  $rhitcount                   = undef,
  $rname                       = undef,
  $rseconds                    = undef,
  $rsource                     = undef,
  $rttl                        = undef,
  $set_dscp                    = undef,
  $set_dscp_class              = undef,
  $set_mark                    = undef,
  $set_mss                     = undef,
  $socket                      = undef,
  $source                      = undef,
  $sport                       = undef,
  $src_cc                      = undef,
  $src_range                   = undef,
  $src_type                    = undef,
  $stat_every                  = undef,
  $stat_mode                   = undef,
  $stat_packet                 = undef,
  $stat_probability            = undef,
  $state                       = undef,
  $string                      = undef,
  $string_algo                 = undef,
  $string_from                 = undef,
  $string_to                   = undef,
  $table                       = undef,
  $tcp_flags                   = undef,
  $time_contiguous             = undef,
  $time_start                  = undef,
  $time_stop                   = undef,
  $to                          = undef,
  $todest                      = undef,
  $toports                     = undef,
  $tosource                    = undef,
  $uid                         = undef,
  $week_days                   = undef,
) {

  # In order to support Puppet 3.x we had to word around
  # https://tickets.puppetlabs.com/browse/PUP-2523.

  # This meant we couldn't pass in $name as part of the hash; it must
  # instead be passed as a separate argument.

  # FIXME. Puppet 3 is no longer supported and this implementation
  # could be changed.

  create_resources(firewall, firewall_multi($name, {
    ensure                => $ensure,
    provider              => $provider,
    action                      => $action,
    burst                       => $burst,
    chain                       => $chain,
    checksum_fill               => $checksum_fill,
    clamp_mss_to_pmtu           => $clamp_mss_to_pmtu,
    clusterip_clustermac        => $clusterip_clustermac,
    clusterip_hash_init         => $clusterip_hash_init,
    clusterip_hashmode          => $clusterip_hashmode,
    clusterip_local_node        => $clusterip_local_node,
    clusterip_new               => $clusterip_new,
    clusterip_total_nodes       => $clusterip_total_nodes,
    connlimit_above             => $connlimit_above,
    connlimit_mask              => $connlimit_mask,
    connmark                    => $connmark,
    ctstate                     => $ctstate,
    date_start                  => $date_start,
    date_stop                   => $date_stop,
    destination                 => $destination,
    dport                       => $dport,
    dst_cc                      => $dst_cc,
    dst_range                   => $dst_range,
    dst_type                    => $dst_type,
    gateway                     => $gateway,
    gid                         => $gid,
    goto                        => $goto,
    hashlimit_above             => $hashlimit_above,
    hashlimit_burst             => $hashlimit_burst,
    hashlimit_dstmask           => $hashlimit_dstmask,
    hashlimit_htable_expire     => $hashlimit_htable_expire,
    hashlimit_htable_gcinterval => $hashlimit_htable_gcinterval,
    hashlimit_htable_max        => $hashlimit_htable_max,
    hashlimit_htable_size       => $hashlimit_htable_size,
    hashlimit_mode              => $hashlimit_mode,
    hashlimit_name              => $hashlimit_name,
    hashlimit_srcmask           => $hashlimit_srcmask,
    hashlimit_upto              => $hashlimit_upto,
    hop_limit                   => $hop_limit,
    icmp                        => $icmp,
    iniface                     => $iniface,
    ipsec_dir                   => $ipsec_dir,
    ipsec_policy                => $ipsec_policy,
    ipset                       => $ipset,
    isfirstfrag                 => $isfirstfrag,
    isfragment                  => $isfragment,
    ishasmorefrags              => $ishasmorefrags,
    islastfrag                  => $islastfrag,
    jump                        => $jump,
    kernel_timezone             => $kernel_timezone,
    length                      => $length,
    limit                       => $limit,
    line                        => $line,
    log_level                   => $log_level,
    log_prefix                  => $log_prefix,
    log_uid                     => $log_uid,
    mac_source                  => $mac_source,
    mask                        => $mask,
    match_mark                  => $match_mark,
    month_days                  => $month_days,
    mss                         => $mss,
    nflog_group                 => $nflog_group,
    nflog_prefix                => $nflog_prefix,
    nflog_range                 => $nflog_range,
    nflog_threshold             => $nflog_threshold,
    outiface                    => $outiface,
    physdev_in                  => $physdev_in,
    physdev_is_bridged          => $physdev_is_bridged,
    physdev_is_in               => $physdev_is_in,
    physdev_is_out              => $physdev_is_out,
    physdev_out                 => $physdev_out,
    pkttype                     => $pkttype,
    port                        => $port,
    proto                       => $proto,
    queue_bypass                => $queue_bypass,
    queue_num                   => $queue_num,
    random                      => $random,
    rdest                       => $rdest,
    reap                        => $reap,
    recent                      => $recent,
    reject                      => $reject,
    rhitcount                   => $rhitcount,
    rname                       => $rname,
    rseconds                    => $rseconds,
    rsource                     => $rsource,
    rttl                        => $rttl,
    set_dscp                    => $set_dscp,
    set_dscp_class              => $set_dscp_class,
    set_mark                    => $set_mark,
    set_mss                     => $set_mss,
    socket                      => $socket,
    source                      => $source,
    sport                       => $sport,
    src_cc                      => $src_cc,
    src_range                   => $src_range,
    src_type                    => $src_type,
    stat_every                  => $stat_every,
    stat_mode                   => $stat_mode,
    stat_packet                 => $stat_packet,
    stat_probability            => $stat_probability,
    state                       => $state,
    string                      => $string,
    string_algo                 => $string_algo,
    string_from                 => $string_from,
    string_to                   => $string_to,
    table                       => $table,
    tcp_flags                   => $tcp_flags,
    time_contiguous             => $time_contiguous,
    time_start                  => $time_start,
    time_stop                   => $time_stop,
    to                          => $to,
    todest                      => $todest,
    toports                     => $toports,
    tosource                    => $tosource,
    uid                         => $uid,
    week_days                   => $week_days,
  }))
}
