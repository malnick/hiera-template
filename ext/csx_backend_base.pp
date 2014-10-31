# profile for csx_backend
class profiles::csx_backend_base (
  $openjdk_version = hiera('profiles::csx_backend_base::openjdk_version')
){
  # Do all pkg config first, kinda a hack but this works so we're doing it.
  stage {'apt-config':
    before => Stage['main']
  }

  class {'::profiles::csx_amber':}
  class {'::profiles::csx_copper':}

  # sets up the apt source for connectsolutions on the client
  class { '::profiles::apt_client_config':
    stage => 'apt-config',
    before => Package['openjdk-7-jdk'],
  }

  package { 'openjdk-7-jdk':
    before   => [ Class['::profiles::csx_amber'], Class['::profiles::csx_copper'] ],
    ensure   => $openjdk_version,
    provider => apt,
  }

  ::tomcat::service { 'default':
    require       => [ Class['::profiles::csx_amber'], Class['::profiles::csx_copper'], ],
    start_command => '/etc/init.d/tomcat7 start',
    stop_command  => '/etc/init.d/tomcat7 stop',
  }
}
