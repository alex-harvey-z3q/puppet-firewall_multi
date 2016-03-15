module Puppet::Parser::Functions
  newfunction(:arrofint2arrofstr, :type => :rvalue) do |args|
    begin
      args[0].map(&:to_s)
    rescue => e
      raise Puppet::ParseError, e
    end
  end
end
