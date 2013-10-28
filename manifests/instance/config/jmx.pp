define collectd::instance::config::jmx(
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

  if !defined(Package['collectd-java']) {
    package { 'collectd-java':
      ensure => $package_name,
    }
  }

  file { "/etc/collectd${instance}.d/jmx":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { "/etc/collectd${instance}.d/jmx/init.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/plugins/jmx/init.conf.erb"),
    require => File["/etc/collectd${instance}.d/jmx"]
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Jmx[$title] ~> Collectd::Instance::Service[$title]

}
