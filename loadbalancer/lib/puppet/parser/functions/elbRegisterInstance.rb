require 'rubygems'
require 'fog'

module Puppet::Parser::Functions
  newfunction(:elbRegisterInstance, :doc => <<-EOS
    Creates a loadbalancer based on the standard configuration. 
    All data and functions are stored in a yaml file within the hiera 
    data structures. There are several hashes that are passed through 
    as arguments to create the configuration for these loadbalancers. 
    EOS
             ) do |args|

    raise(Puppet::ParseError, "values(): Wrong number of arguments " +
      "given (#{args.size} for 3)") if args.size < 3

    # get all the arguments into a usable format
    envname = args[0]
    aws_creds = args[1]
    instance_id = args[2]

    # Do some sanity checking on arguments to ensure they are the correct data types
    unless aws_creds.is_a?(Hash)
      raise(Puppet::ParseError, 'values(): Requires hash to work with')
    end

    unless instance_id.is_a?(Array)
      raise(Puppet::ParseError, 'values(): Requires array to work with')
    end    
     
    # Create a new fog instance 
    elb = Fog::AWS::ELB.new(
      :aws_access_key_id => aws_creds['aws_access_key'], 
      :aws_secret_access_key => aws_creds['aws_secret_key'],
     ) 

    # Create the Health check
    elb.register_instances_with_load_balancer(instance_id, "lb-#{envname}")

  end
end
