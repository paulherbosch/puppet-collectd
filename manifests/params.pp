class collectd::params {

  case $::operatingsystemrelease {
    /^5./: {
      $package_name = '5.2.0-6.cgk.el5'
    }
    /^6./: {
      $package_name = '5.2.0-6.cgk.el6'
    }
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }

}
