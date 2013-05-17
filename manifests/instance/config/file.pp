define collectd::instance::config::file($instance='', $plugin_type=undef, $file_name=undef, $source=undef) {

  if $plugin_type == undef {
    fail("Collectd::Instance::Config::File[${title}]: parameter plugin_type must be present")
  }

  if $file_name == undef {
    fail("Collectd::Instance::Config::File[${title}]: parameter file_name must be present")
  }

  if ($source == undef) {
    fail("Collectd::Instance::Config::File[${title}]: parameter source must be present")
  }

  file { "/etc/collectd${instance}.d/${plugin_type}/${file_name}":
    ensure => file,
    source => $source
  }

}
