class collectd::params {

  case $::operatingsystemrelease {
    /^5./: {
      $package_name = '5.2.0-6.cgk.el5'
    }
    /^6./: {
      $package_name = '5.2.0-6.cgk.el6'
    }
    /^7./: {
      $package_name = '5.7.0-1.cgk.el7'
    }
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }

}
