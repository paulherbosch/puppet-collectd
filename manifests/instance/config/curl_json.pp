define collectd::instance::config::curl_json(
  $version='present'
) {


  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  case $::operatingsystemrelease {
    /^[56]\./: {
      if !defined(Package['collectd-curl_json']) {
        package { 'collectd-curl_json':
          ensure => $version,
        }
      }

      file { "/etc/collectd${instance}.d/curl_json":
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }

      file { "/etc/collectd${instance}.d/curl_json/init.conf":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("${module_name}/plugins/curl_json/init.conf.erb"),
        require => File["/etc/collectd${instance}.d/curl_json"],
        notify  => Service["collectd${instance}"]
      }

      Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Curl_json[$title] ~> Collectd::Instance::Service[$title]
    }
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }
}
