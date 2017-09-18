define collectd::instance::config::file($instance='', $plugin_type=undef, $file_name=undef, $source=undef, $content=undef) {

  if $plugin_type == undef {
    fail("Collectd::Instance::Config::File[${title}]: parameter plugin_type must be present")
  }

  if $file_name == undef {
    fail("Collectd::Instance::Config::File[${title}]: parameter file_name must be present")
  }

  if (($source == undef) and ($content == undef)) {
    fail("Collectd::Instance::Config::File[${title}]: parameter source or content must be present")
  }

  if ($source) {
    file { "/etc/collectd${instance}.d/${plugin_type}/${file_name}":
      ensure => file,
      source => $source,
      notify => Service["collectd${instance}"]
    }
  }

  if ($content) {
    file { "/etc/collectd${instance}.d/${plugin_type}/${file_name}":
      ensure => file,
      content => template($content),
      notify => Service["collectd${instance}"]
    }
  }

}
