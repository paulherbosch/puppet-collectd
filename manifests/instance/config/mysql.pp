define collectd::instance::config::mysql (
  $database_items=[],
  $version='present'
) {

  include collectd::params

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  case $::operatingsystemrelease {
    /^[56]\./: {
      if !defined(Package['collectd-mysql']) {
        package { 'collectd-mysql':
          ensure  => $version,
        }
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
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }
}
