define collectd::instance::config::jmx() {

  include collectd::params

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
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
    content => "LoadPlugin java\nInclude \"/etc/collectd${instance}.d/jmx/jmx_*.conf\"\n"
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Jmx[$title] ~> Collectd::Instance::Service[$title]

}
