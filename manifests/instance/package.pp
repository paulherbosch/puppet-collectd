class collectd::instance::package {

  include collectd::params

  if !defined(Package['collectd']) {
    package { 'collectd':
      ensure => $package_name
    }
  }

}
