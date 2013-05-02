define collectd::instance::config::mysql ($database_items=[]) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  file { "/etc/collectd${instance}.d/mysql":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { "/etc/collectd${instance}.d/mysql/init.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("collectd/plugins/mysql.conf.erb"),
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Mysql[$title] ~> Collectd::Instance::Service[$title]
}
