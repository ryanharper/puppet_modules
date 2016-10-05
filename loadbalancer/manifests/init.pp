# == Class: loadbalancer
#
# Initializes the loadbalancer class.
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
#
# Author Name <Author Name <ryanharper007@zer0touch.co.uk>
#
# === Copyright
#
#
class loadbalancer {
  include loadbalancer::create
  include loadbalancer::register
  Class['loadbalancer::create'] -> Class['loadbalancer::register']
}
