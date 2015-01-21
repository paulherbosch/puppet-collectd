# Use namevar = 'default' to create the default collectd instance (service collectd)

define collectd::instance ($interval = '30', $version = 'present') {
  # namevar = 'default' => default collectd service.
  # Other value, e.g. '10s' => create second collectd instance collectd10s...
  # default service is always installed (because it is required by other optional collectd instances)

  if !defined(Class['collectd::instance::package']) {
    class { 'collectd::instance::package':
      version => $version,
    }
  }

  collectd::instance::config { $title:
    interval => $interval,
    require  => Class['collectd::instance::package'],
  }

  collectd::instance::service { $title:
    subscribe => Collectd::Instance::Config[$title],
  }
}
