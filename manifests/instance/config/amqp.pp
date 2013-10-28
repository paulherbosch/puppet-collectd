define collectd::instance::config::amqp (
  $exchange,
  $host = 'localhost',
  $port = '5672',
  $user = 'guest',
  $password = 'guest',
  $messageFormat = 'graphite',
  $graphitePrefix = 'collectd.',
  $release = '5.2.0-6'
) {

  include collectd::params

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

  if !defined(Package['collectd-amqp']) {
    package { 'collectd-amqp':
      ensure  => $package_name,
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
    content => template('collectd/plugins/amqp.conf.erb'),
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Amqp[$title] ~> Collectd::Instance::Service[$title]
}
