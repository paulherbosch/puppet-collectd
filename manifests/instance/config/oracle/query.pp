define collectd::instance::config::oracle::query ($collectd_instance, $sqlstatement, $results) {

  if $collectd_instance != 'default' {
    $instance = $collectd_instance
  } else {
    $instance = ''
  }

  if !defined (Concat::Fragment["fragment_query_conf_header_${name}"]) {

    # Build q_<name>.conf using concat/fragments and templates
    concat { "query_conf_file_${name}":
      path    => "/etc/collectd${instance}.d/oracle/q_${name}.conf",
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package['collectd-oracle'],
      notify  => Service["collectd${instance}"],
    }

    concat::fragment {"fragment_query_conf_header_${name}":
      target  => "query_conf_file_${name}",
      order   => '10',
      content => "<Plugin oracle>\n",
    }
  }

  concat::fragment {"fragment_query_conf_${name}":
    target  => "query_conf_file_${name}",
    order   => '20',
    content => template("${module_name}/databasequery.conf.erb"),
  }

  if !defined (Concat::Fragment["fragment_query_conf_trailer_${name}"]) {
    concat::fragment { "fragment_query_conf_trailer_${name}":
      target  => "query_conf_file_${name}",
      order   => '30',
      content => "</Plugin>\n",
    }
  }
}
