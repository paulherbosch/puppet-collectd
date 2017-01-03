define collectd::instance::config::tcpconns (
  $tcp_connections_items=[],
) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  file { "/etc/collectd${instance}.d/tcpconns":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { "/etc/collectd${instance}.d/tcpconns/init.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('collectd/plugins/tcpconns.conf.erb'),
    notify  => Service["collectd${instance}"]
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Tcpconns[$title] ~> Collectd::Instance::Service[$title]

}
