# == Class: loadbalancer::register
#
# This class registers the particular instances on the elb.
# TODO : this should be parameterized to allow for other provider control
#
# === Parameters
#
# === Variables
#
# === Authors
#
# Author Name <ryanharper007@zer0touch.co.uk
#
# === Copyright
#
#
class loadbalancer::register {
  # We do not want loadbalancers for standalone environments.
  if $::env_profile != 'standalone' {
    $health_check         = hiera('health_check')
    $elb_zones            = hiera("elb_${::env_client}_${::env_type}_zones")
    $lb_listener_policies = hiera('lb_listener_policies')
    $aws_credentials      = hiera("aws_${::env_client}_${::env_type}_credentials")
    $elb_policy           = hiera('elb_policy')
    $elb_listeners        = hiera('elb_listeners')
    # push the instance id to an array as the method expects this data format
    $instance_id          = [$::ec2_instance_id]
    # Custom server side function to create a loadbalancer
    elbRegisterInstance($::envname, $aws_credentials, $instance_id)
  }

}
