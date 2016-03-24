module Puppet::Parser::Functions
  newfunction(:firewall_multi,
    :arity => 1,
    :type  => :rvalue,
    :doc   => "

Takes a Hash and returns a modified Hash suitable for input to
create_resources().

For example:

{
  '00100 accept inbound ssh' => {
    'action' => 'accept',
    'source' => ['1.1.1.1/24', '2.2.2.2/24'],
    'dport'  => 22,
  },
}

Becomes:

{
  '00100 accept inbound ssh from 1.1.1.1/24' => {
    'action' => 'accept',
    'source' => '1.1.1.1/24',
    'dport'  => 22,
  },
  '00100 accept inbound ssh from 2.2.2.2/24' => {
    'action' => 'accept',
    'source' => '2.2.2.2/24',
    'dport'  => 22,
  },
}

") do |args|

    raise ArgumentError, ('firewall_multi(): ' +
      'first argument must be a hash') unless args[0].is_a?(Hash)

    extend Puppet::Parser::Functions

    def self.explode(hash, opts = {})
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

    rval = args[0]
    rval = explode(rval, {
      :param  => 'source',
      :string => 'from',
    })
    rval = explode(rval, {
      :param  => 'destination',
      :string => 'to',
    })
    rval = explode(rval, {
      :param  => 'icmp',
      :string => 'icmp type',
    })
    rval

  end
end
