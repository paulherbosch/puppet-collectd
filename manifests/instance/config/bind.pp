define collectd::instance::config::bind (
  $url='http://localhost:8053',
  $opcodes=true,
  $qtypes=true,
  $serverstats=true,
  $zonemaintstats=true,
  $resolverstats=false,
  $memorystats=true,
  $zones=undef,
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

  if !defined(Package['collectd-bind']) {
    package { 'collectd-bind':
      ensure  => $package_name,
    }
  }

  file { "/etc/collectd${instance}.d/bind":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Create /etc/collectd${instance}.d/bind/init.conf
  file { "/etc/collectd${instance}.d/bind/init.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('collectd/plugins/bind.conf.erb'),
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Bind[$title] ~> Collectd::Instance::Service[$title]
}
