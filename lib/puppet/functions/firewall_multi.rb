# Convert firewall_multi type data to firewall type data.
Puppet::Functions.create_function(:firewall_multi) do
  # @summary Take a name and a hash and return a modified hash suitable
  #   for input to create_resources().
  #
  # @example Given this input:
  #
  #   ```ruby
  #   [
  #     '00100 accept inbound ssh',
  #     {
  #       'action' => 'accept',
  #       'source' => ['1.1.1.1/24', '2.2.2.2/24'],
  #       'dport'  => 22,
  #     }
  #   ]
  #   ```
  #
  #   Return this:
  #
  #   ```ruby
  #   {
  #     '00100 accept inbound ssh from 1.1.1.1/24' => {
  #       'action' => 'accept',
  #       'source' => '1.1.1.1/24',
  #       'dport'  => 22,
  #     },
  #     '00100 accept inbound ssh from 2.2.2.2/24' => {
  #       'action' => 'accept',
  #       'source' => '2.2.2.2/24',
  #       'dport'  => 22,
  #     },
  #   }
  #   ```
  #
  # @note It would be more natural to accept input structured as:
  #
  #   ```ruby
  #   [
  #     {
  #       '00100 accept inbound ssh' => {
  #         'action' => 'accept',
  #         'source' => ['1.1.1.1/24', '2.2.2.2/24'],
  #         'dport'  => 22,
  #       },
  #     }
  #   ]
  #   ```
  #
  #   However $name would need to be passed in as the hash key in the
  #   manifest whereas we must work around [PUP-2523](https://tickets.puppetlabs.com/browse/PUP-2523).
  #
  # @param name The original resource title.
  # @param hash The original resource params data.
  # @return Modified Hash for firewall types to be passed to create_resources().
  #
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
    rval = explode(rval, {
      :param  => 'provider',
      :string => 'using provider',
    })
    rval
  end
end
