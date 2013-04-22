define collectd::instance::config::bind (
  $url='http://localhost:8053',
  $opcodes=true,
  $qtypes=true,
  $serverstats=true,
  $zonemaintstats=true,
  $resolverstats=false,
  $memorystats=true,
  $zones=undef
) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
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
    content => template("${module_name}/bind.conf.erb"),
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Bind[$title] ~> Collectd::Instance::Service[$title]
}
