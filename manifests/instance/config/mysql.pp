define collectd::instance::config::mysql (
  $database_items=[],
  $release='5.2.0-6'
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

  if !defined(Package['collectd-mysql']) {
    package { 'collectd-mysql':
      ensure  => $package_name,
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
    content => template("collectd/plugins/mysql.conf.erb"),
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Mysql[$title] ~> Collectd::Instance::Service[$title]
}
