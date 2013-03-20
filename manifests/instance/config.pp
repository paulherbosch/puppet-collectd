define collectd::instance::config ($interval) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  # Create service script in /etc/init.d
  file { "/etc/init.d/collectd${instance}":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => '/etc/init.d/collectd',
  }

  # Create /etc/collectd${instance}.conf
  file { "collectd${instance}.conf":
    ensure  => file,
    path    => "/etc/collectd${instance}.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => '/etc/collectd.conf',
    replace => false,
  }

  file { "/etc/collectd${instance}.d":
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  # Include directive /etc/collectd.d/*/init.conf -> this include can handle all possible configurations,
  # assuming that the config files are in a subdirectory like /etc/collectd.d/<plugin name>/init.conf;
  # init.conf can optionally include other config files.
  augeas { "collectd${instance}.conf.1":
    lens    => 'Httpd.lns',
    incl    => "/etc/collectd${instance}.conf",
    changes => [
      "set directive[.=\"Include\"]/ 'Include'",
      "set directive[.=\"Include\"]/arg '\"/etc/collectd${instance}.d/*/init.conf\"'",
    ],
    require => File["collectd${instance}.conf"],
  }

  augeas { "collectd${instance}.conf.2":
    lens    => 'Httpd.lns',
    incl    => "/etc/collectd${instance}.conf",
    changes => [
      "set directive[.=\"Interval\"]/ 'Interval'",
      "set directive[.=\"Interval\"]/arg '${interval}'",
    ],
    require => Augeas["collectd${instance}.conf.1"],
  }

  # Set PID file in collectd config file (--pidfile in init scropt's daemon command may not work)
  augeas { "collectd${instance}.conf.3":
    lens    => 'Httpd.lns',
    incl    => "/etc/collectd${instance}.conf",
    changes => [
      "set directive[.=\"PIDFile\"]/ 'PIDFile'",
      "set directive[.=\"PIDFile\"]/arg '\"/var/run/collectd${instance}.pid\"'",
    ],
    require => Augeas["collectd${instance}.conf.2"],
  }
}
