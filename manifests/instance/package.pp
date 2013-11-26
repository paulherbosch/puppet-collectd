class collectd::instance::package ($version = 'present') {

  case $::operatingsystemrelease {
    /^[56]\./: {
      if !defined(Package['collectd']) {
        package { 'collectd':
          ensure => $version
        }
      }
    }
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }
}
