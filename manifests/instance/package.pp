class collectd::instance::package {
  if !defined(Package['collectd']) {
    package { 'collectd':
      ensure => '5.2.0-5.cegeka'
    }
  }
}
