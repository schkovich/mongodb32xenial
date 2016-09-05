# Class: mongodb32xenial
# ===========================
#
# Full description of class mongodb32xenial here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'mongodb32xenial':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Goran Miskovic <schkovich@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2016 Goran Miskovic, unless otherwise noted.
#
class mongodb32xenial (
  # default values are in mongodb32xenial/data
  $version,
  $manage_package_repo,
  $server_package_name,
  $mongodb_service_name,
  $client_package_name,
  $port,
  $dbname,
  $dbadmin,
  $admin_password,
  $dbuser,
  $password
){

  class {'mongodb32xenial::repo': }

  if versioncmp($version, '3.2.9') < 0 {

    file { 'mongodsr':
      ensure  => present,
      path    => '/etc/systemd/system/mongod.service',
      backup  => false,
      source  => 'puppet:///modules/mongodb32xenial/mongod.service',
      require => Class['mongodb32xenial::repo']
    }

    class {'::mongodb::globals':
      version             => $version,
      manage_package_repo => $manage_package_repo,
      server_package_name => $server_package_name,
      service_name        => $mongodb_service_name,
      require             => File['mongodsr'],
    }
  } else {

    class {'::mongodb::globals':
      version             => $version,
      manage_package_repo => $manage_package_repo,
      server_package_name => $server_package_name,
      service_name        => $mongodb_service_name,
      require             => Class['mongodb32xenial::repo'],
    }

  }

  class {'::mongodb::server':
    port    => $port,
    verbose => true,
    require => Class['::mongodb::globals']
  }

  class {'::mongodb::client':
    package_name => $client_package_name,
    require      => Class['::mongodb::server']
  }

}
