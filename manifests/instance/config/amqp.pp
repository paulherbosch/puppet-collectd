define collectd::instance::config::amqp ($exchange, $host = 'localhost', $port = '5672', $user = 'guest',
    $password = 'guest', $messageFormat = 'graphite', $graphitePrefix = 'collectd.') {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  if !defined(Package['collectd-amqp']) {
    package { 'collectd-amqp':
      ensure  => '5.2.0-5.cegeka',
    }
  }

  file { "/etc/collectd${instance}.d/amqp":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Create /etc/collectd${instance}.d/amqp/init.conf
  file { "/etc/collectd${instance}.d/amqp/init.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/amqp.conf.erb"),
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Amqp[$title] ~> Collectd::Instance::Service[$title]
}
