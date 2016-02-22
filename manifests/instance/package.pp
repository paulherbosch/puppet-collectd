class collectd::instance::package ($version = 'present') {

  package { 'collectd':
    ensure => $version
  }
}
