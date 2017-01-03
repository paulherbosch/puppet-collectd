define collectd::instance::config::mysql (
  $database_items=[],
  $version='present'
) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  package { 'collectd-mysql':
    ensure  => $version,
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
    content => template('collectd/plugins/mysql.conf.erb'),
    notify  => Service["collectd${instance}"]
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Mysql[$title] ~> Collectd::Instance::Service[$title]

}
