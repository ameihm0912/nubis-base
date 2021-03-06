class { 'consul':
  version     => '0.6.4',
  service_enable => false,
  service_ensure => 'stopped',
  manage_service => false,
  config_hash => {
      'data_dir'      => '/var/lib/consul',
      'log_level'     => 'INFO',
      'ui_dir'        => '/var/lib/consul/ui',
      'client_addr'   => '0.0.0.0',
      'server'        => false,
      'enable_syslog' => true,
  }
}

# initv startup script is borked
case $::osfamily {
  'redhat': {
    package { "daemonize":
      ensure => 'present',
      install_options => [ '--enablerepo=epel' ],
    }
  }
}

# Install latest known consul-do
class { 'consul_do':
  version => "404d6180650e72e1881a260dab8d645815832c9e"
}

class { 'consul_template':
    service_enable   => false,
    service_ensure   => 'stopped',
    version          => '0.11.0',
    user             => 'root',
    group            => 'root',
}

# Package['tar'] is defined by consul_template above
class { 'envconsul':
  version  => '0.5.0',
  require  => Package['tar'],
}
