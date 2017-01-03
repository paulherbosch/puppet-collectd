define collectd::instance::config::snmp (
  $configfile,
  $version='present'
) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  package { 'collectd-snmp':
    ensure  => $version,
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
    notify  => Service["collectd${instance}"]
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Snmp[$title] ~> Collectd::Instance::Service[$title]

}
