define collectd::instance::config::jmx_wildfly(
  $version='present',
  $wildfly_home = '/opt/wildfly'
) {


  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

      package { 'collectd-java':
        ensure => $version,
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
        content => template("${module_name}/plugins/jmx_wildfly/init.conf.erb"),
        require => File["/etc/collectd${instance}.d/jmx"],
        notify  => Service["collectd${instance}"]
      }

      file { '/usr/share/collectd/java/generic-jmx-wildfly.jar':
        ensure  => file,
        mode    => '0644',
        source  => "puppet:///modules/${module_name}/generic-jmx-wildfly.jar",
        notify  => Service["collectd${instance}"]
      }

      Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Jmx_wildfly[$title] ~> Collectd::Instance::Service[$title]
    }
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }
}
