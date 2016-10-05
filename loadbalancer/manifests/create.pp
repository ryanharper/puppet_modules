# == Class: loadbalancer::create
#
# This creates dns entries for route 53 on AWS
# TODO : This needs to parameterized for provider specific configurations
#
# === Parameters
#
# === Variables
#
# === Authors
#
# Author Name <ryanharper007@zer0touch.co.uk>
#
# === Copyright
#
# 

class loadbalancer::create {
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
    elbCreate($::envname, $aws_credentials, $health_check, $elb_zones, $lb_listener_policies, $elb_policy, $elb_listeners)
  }
}
