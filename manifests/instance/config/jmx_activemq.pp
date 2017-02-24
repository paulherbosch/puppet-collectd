define collectd::instance::config::jmx_activemq(
  $version='present',
  $activemq_home = $activemq_home
) {
  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  package { 'collectd-java':
    ensure => $version,
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
    content => template("${module_name}/plugins/jmx_activemq/init.conf.erb"),
    require => File["/etc/collectd${instance}.d/jmx"],
    notify  => Service["collectd${instance}"]
  }

  file { '/usr/share/collectd/java/generic-jmx-activemq.jar':
    ensure  => file,
    mode    => '0644',
    source  => "puppet:///modules/${module_name}/generic-jmx-activemq.jar",
    notify  => Service["collectd${instance}"]
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Jmx_activemq[$title] ~> Collectd::Instance::Service[$title]

}
