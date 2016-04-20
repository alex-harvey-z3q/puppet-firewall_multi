# Take a name and a hash and return a modified hash suitable for input to
# create_resources().
#
# Given this input:
#
# [
#   '00100 accept inbound ssh',
#   {
#     'action' => 'accept',
#     'source' => ['1.1.1.1/24', '2.2.2.2/24'],
#     'dport'  => 22,
#   }
# ]
#
# Return this:
#
# {
#   '00100 accept inbound ssh from 1.1.1.1/24' => {
#     'action' => 'accept',
#     'source' => '1.1.1.1/24',
#     'dport'  => 22,
#   },
#   '00100 accept inbound ssh from 2.2.2.2/24' => {
#     'action' => 'accept',
#     'source' => '2.2.2.2/24',
#     'dport'  => 22,
#   },
# }
#
# Note that it would be more natural to accept input structured as:
#
# [
#   {
#     '00100 accept inbound ssh' => {
#       'action' => 'accept',
#       'source' => ['1.1.1.1/24', '2.2.2.2/24'],
#       'dport'  => 22,
#     },
#   }
# ]
#
# However $name would need to be passed in as the hash key in the 
# manifest whereas we must work around this bug:
# https://tickets.puppetlabs.com/browse/PUP-2523

Puppet::Functions.create_function(:firewall_multi) do
  dispatch :firewall_multi do
    param 'String', :name
    param 'Hash', :hash
  end

  def explode(hash, opts = {})
    _hash = Hash.new
    hash.each do |title, params|
      if params.has_key?(opts[:param]) and
        params[opts[:param]].is_a?(Array)
        params[opts[:param]].each do |v|
          _title = [title, opts[:string], v].join(' ')
          _hash[_title] = params.clone
          _hash[_title][opts[:param]] = v
        end
      else
        _hash[title] = params.clone
      end
    end
    _hash
  end

  def firewall_multi(name, hash)
    rval = {
      name => hash
    }

    rval = explode(rval, {
      :param  => 'source',
      :string => 'from',
    })
    rval = explode(rval, {
      :param  => 'destination',
      :string => 'to',
    })
    rval = explode(rval, {
      :param  => 'proto',
      :string => 'protocol',
    })
    rval = explode(rval, {
      :param  => 'icmp',
      :string => 'icmp type',
    })
    rval
  end
end
