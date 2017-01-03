# Class: proftpd
#
# This module manages proftpd
#
# Parameters:
# * ensure
# * program: { application1 => { 'user' => 'someuser', 'command' => 'somecommand' } }
# Actions:
#
# Requires:
#
# Sample Usage:
#
define collectd::instance::config::exec (
  $ensure=present,
  $program=undef,
) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  file { "/etc/collectd${instance}.d/exec":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { "/etc/collectd${instance}.d/exec/init.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('collectd/plugins/exec.conf.erb'),
    notify  => Service["collectd${instance}"]
  }

  Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Exec[$title] ~> Collectd::Instance::Service[$title]

}
