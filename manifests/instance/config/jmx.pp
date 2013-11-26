define collectd::instance::config::jmx(
  $version='present'
) {


  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  case $::operatingsystemrelease {
    /^[56]\./: {
      if !defined(Package['collectd-java']) {
        package { 'collectd-java':
          ensure => $version,
        }
      }

      file { "/etc/collectd${instance}.d/jmx":
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }

      file { "/etc/collectd${instance}.d/jmx/init.conf":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("${module_name}/plugins/jmx/init.conf.erb"),
        require => File["/etc/collectd${instance}.d/jmx"]
      }

      Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Jmx[$title] ~> Collectd::Instance::Service[$title]
    }
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }
}
