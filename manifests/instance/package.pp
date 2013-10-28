class collectd::instance::package ($release='5.2.0-6') {

  case $::operatingsystemrelease {
    /^5./: {
      $package_name = "${release}.cgk.el5"
    }
    /^6./: {
      $package_name = "${release}.cgk.el6"
    }
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }

  if !defined(Package['collectd']) {
    package { 'collectd':
      ensure => $package_name
    }
  }

}
