collectd::instance {'default':
  interval  => 60,
  version   => '5.2.2-3',
}
collectd::instance::config::exec { 'default':
  program => { ftp_stats => { "user" => "root" , "command" => "grep -c /etc/passwd" } }
}
