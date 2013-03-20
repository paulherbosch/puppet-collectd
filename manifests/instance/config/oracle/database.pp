define collectd::instance::config::oracle::database ($collectd_instance, $connectID, $username, $password, $queries = []) {

  if $collectd_instance != 'default' {
    $instance = $collectd_instance
  } else {
    $instance = ''
  }

  if !defined (Concat::Fragment["fragment_databases_conf_header_${instance}"]) {

    # Build databases.conf using concat/fragments and templates
    concat { "databases_conf_file_${instance}":
      path    => "/etc/collectd${instance}.d/oracle/databases.conf",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package['collectd-oracle'],
      notify  => Service["collectd${instance}"],
    }

    concat::fragment {"fragment_databases_conf_header_${instance}":
      target  => "databases_conf_file_${instance}",
      order   => '10',
      content => "<Plugin oracle>\n",
    }
  }

  concat::fragment {"fragment_databases_conf_${instance}_${name}":
    target  => "databases_conf_file_${instance}",
    order   => '20',
    content => template("${module_name}/databases.conf.erb"),
  }

  if !defined (Concat::Fragment["fragment_databases_conf_trailer_${instance}"]) {
    concat::fragment { "fragment_databases_conf_trailer_${instance}":
      target  => "databases_conf_file_${instance}",
      order   => '30',
      content => "</Plugin>\n",
    }
  }
}
