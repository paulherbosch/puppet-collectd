define collectd::instance::config::snmp (
  $configfile,
  $release='5.2.0-6'
) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

 case $::operatingsystemrelease {
    /^5./: {
      $package_name = "${release}.cgk.el5"
    }
    /^6./: {
      $package_name = "${release}.cgk.el6"
    }
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }

  if !defined(Package['collectd-snmp']) {
    package { 'collectd-snmp':
      ensure  => $package_name,
    }
  } 

  file { "/etc/collectd${instance}.d/snmp":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Create /etc/collectd${instance}.d/snmp/init.conf
  file { "/etc/collectd${instance}.d/snmp/init.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file($configfile),
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Snmp[$title] ~> Collectd::Instance::Service[$title]
}
