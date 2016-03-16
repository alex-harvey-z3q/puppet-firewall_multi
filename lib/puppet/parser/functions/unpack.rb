module Puppet::Parser::Functions
  newfunction(:unpack, :type => :rvalue) do |args|

    raise(Puppet::ParseError,
      "unpack() wrong number of arguments. Given: #{args.size} for 1)") if args.size != 1

    myarr = args[0].split(/__/)

    description = myarr[0]
    from        = ''
    to          = ''
    icmp        = ''

    if myarr[1] == 'undef'
      from = nil
    else
      description << ' from ' + myarr[1]
      from = myarr[1]
    end

    if myarr[2] == 'undef'
      to = nil
    else
      description << ' to ' + myarr[2]
      to = myarr[2]
    end

    if myarr[3] == 'undef'
      icmp = nil
    else
      description << ' icmp type ' + myarr[3]
      icmp = myarr[3]
    end

    {
      'description' => description,
      'from'        => from,
      'to'          => to,
      'icmp'        => icmp,
    }

  end
end
