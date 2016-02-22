define collectd::instance::config::oracle (
  $version='present'
){

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  case $::operatingsystemrelease {
    /^[567]\./: {
      if !defined(Package['collectd-oracle']) {
        package { 'collectd-oracle':
          ensure  => $version,
        }
      }

      if !defined(Package['oracle-instantclient']) {
        # Oracle instantclient packages
        package { 'oracle-instantclient':
          ensure => '11.2.0.2.0-5.cegeka'
        }
      }

      if !defined(Package['oracle-instantclient-sqlplus']) {
        package { 'oracle-instantclient-sqlplus':
          ensure  => '11.2.0.2.0-5.cegeka',
          require => Package['oracle-instantclient']
        }
      }

      if !defined(Package['oracle-instantclient-tools']) {
        package { 'oracle-instantclient-tools':
          ensure  => '11.2.0.2.0-5.cegeka',
          require => Package['oracle-instantclient']
        }
      }

      file { "/etc/default/collectd${instance}":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => "puppet:///modules/${module_name}/collectd_default"
      }

      file { "/etc/collectd${instance}.d/oracle":
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
      }

      file { "/etc/collectd${instance}.d/oracle/init.conf":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("${module_name}/initoracle.conf.erb"),
        notify  => Service["collectd${instance}"]
      }

      Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Oracle[$title] ~> Collectd::Instance::Service[$title]
    }
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }
}
