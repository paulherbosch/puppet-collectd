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

  include collectd::params

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  case $::operatingsystemrelease {
    /^[56]\./: {
      if !defined(Package['collectd-amqp']) {
        package { 'collectd-amqp':
          ensure  => $version,
        }
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
      }

      Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Amqp[$title] ~> Collectd::Instance::Service[$title]
    }
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }
}
