require 'rubygems'
require 'fog'

module Puppet::Parser::Functions
  newfunction(:elbGetDns, :type => :rvalue, :doc => <<-EOS
    Returns the loadbalancer dns name for the given environment, this 
    is only applicable to bronze/silver/gold environments. 
    EOS
             ) do |args|

    raise(Puppet::ParseError, "values(): Wrong number of arguments " +
      "given (#{args.size} for 2)") if args.size < 2

    # get all the arguments into a usable format
    envname = args[0]
    aws_creds = args[1]
    
    # Do some sanity checking on arguments to ensure they are the correct data types
    unless aws_creds.is_a?(Hash)
      raise(Puppet::ParseError, 'values(): Requires hash to work with')
    end
     
    # Create a new fog instance 
    elb = Fog::AWS::ELB.new(
      :aws_access_key_id => aws_creds['aws_access_key'], 
      :aws_secret_access_key => aws_creds['aws_secret_key'],
     ) 

    elbdns = elb.load_balancers.get("lb-#{envname}").dns_name
    return elbdns
  end
end

