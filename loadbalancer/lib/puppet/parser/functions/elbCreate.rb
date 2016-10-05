require 'rubygems'
require 'fog'

module Puppet::Parser::Functions
  newfunction(:elbCreate, :doc => <<-EOS
    Creates a loadbalancer based on a standard configuration. 
    All data and functions are stored in a yaml file within the hiera 
    data structures. There are several hashes that are passed through 
    as arguments to create the configuration for these loadbalancers. 
    EOS
             ) do |args|

    raise(Puppet::ParseError, "values(): Wrong number of arguments " +
      "given (#{args.size} for 7)") if args.size < 7

    # get all the arguments into a usable format
    envname = args[0]
    aws_creds = args[1]
    health_check = args[2]
    zones = args[3]
    lb_listener_policies = args[4]
    elb_policy = args[5]
    elb_listeners = args[6]

    # Do some sanity checking on arguments to ensure they are the correct data types
    unless aws_creds.is_a?(Hash)
      raise(Puppet::ParseError, 'values(): Requires hash to work with')
    end

    unless health_check.is_a?(Hash)
      raise(Puppet::ParseError, 'values(): Requires hash to work with')
    end

    unless zones.is_a?(Array)
      raise(Puppet::ParseError, 'values(): Requires Array to work with')
    end

    unless zones.is_a?(Array)
      raise(Puppet::ParseError, 'values(): Requires Array to work with')
    end

    unless lb_listener_policies.is_a?(Array)
      raise(Puppet::ParseError, 'values(): Requires Array to work with')
    end

    unless elb_policy.is_a?(Array)
      raise(Puppet::ParseError, 'values(): Requires Array to work with')
    end

    unless elb_listeners.is_a?(Array)
      raise(Puppet::ParseError, 'values(): Requires Array to work with')
    end
  
    # Create a new fog instance 
    elb = Fog::AWS::ELB.new(
      :aws_access_key_id => aws_creds['aws_access_key'], 
      :aws_secret_access_key => aws_creds['aws_secret_key'],
     ) 

    # Create the loadbalancer
    elb.create_load_balancer(zones, "lb-#{envname}", elb_listeners)

    # Create the Health check
    elb.configure_health_check("lb-#{envname}", health_check)

    #elb.create_lb_cookie_stickiness_policy('lb-ryanstest008', 'fiveHourPolicy', 18000)
    elb.create_lb_cookie_stickiness_policy(elb_policy[0], elb_policy[1], elb_policy[2])

    # Loop through the array and add all the policies to the defined listeners
    lb_listener_policies.each do |t|
      elb.set_load_balancer_policies_of_listener(t[0], t[1], t[2])
    end
  end
end


