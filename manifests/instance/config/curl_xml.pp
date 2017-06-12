define collectd::instance::config::curl_xml(
  $version='present'
) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  package { 'collectd-curl_xml':
    ensure => $version,
  }

  file { "/etc/collectd${instance}.d/curl_xml":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { "/etc/collectd${instance}.d/curl_xml/init.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/plugins/curl_xml/init.conf.erb"),
    require => File["/etc/collectd${instance}.d/curl_xml"],
    notify  => Service["collectd${instance}"]
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Curl_xml[$title] ~> Collectd::Instance::Service[$title]

}
