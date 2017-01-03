define collectd::instance::config::amqp (
  $exchange,
  $host = 'localhost',
  $port = '5672',
  $user = 'guest',
  $password = 'guest',
  $messageFormat = 'graphite',
  $graphitePrefix = 'collectd.',
  $version = 'present'
) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  package { 'collectd-amqp':
    ensure  => $version,
  }

  file { "/etc/collectd${instance}.d/amqp":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { "/etc/collectd${instance}.d/amqp/init.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('collectd/plugins/amqp.conf.erb'),
    notify  => Service["collectd${instance}"]
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Amqp[$title] ~> Collectd::Instance::Service[$title]

}
