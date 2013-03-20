define collectd::instance::service {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  service { "collectd${instance}":
    ensure     => running,
    enable     => true,
  }
}
