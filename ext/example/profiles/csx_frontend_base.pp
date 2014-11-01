# profile for deploying csx_frontend: includes mysql setup, custom apt repo setup, and installation of tomcat, java, and productization.war
# you should view cs_csx_frontend::productization for key hiera variables to pass in with automatic parameter lookup
# you should view cs_apt_client for key hiera variables to pass in as well (default set to datapipe commercial configuration)
class profiles::csx_frontend_base(
  $csx_db_name                          = hiera('profiles::csx_frontend_base::csx_db_name'),
  $csx_db_user                          = hiera('profiles::csx_frontend_base::csx_db_user'),
  $csx_db_password_hash                 = hiera('profiles::csx_frontend_base::csx_db_password_hash'),
  $csx_db_host                          = hiera('profiles::csx_frontend_base::csx_db_host'),
  $csx_db_driverclassname               = hiera('profiles::csx_frontend_base::csx_db_driverclassname'),
  $csx_db_url                           = hiera('profiles::csx_frontend_base::csx_db_url'),
  $csx_db_password                      = hiera('profiles::csx_frontend_base::csx_db_password'),
  $mandrill_apikey                      = hiera('profiles::csx_frontend_base::mandrill_apikey'),
  $mandrill_username                    = hiera('profiles::csx_frontend_base::mandrill_username'),
  $middleware_url                       = hiera('profiles::csx_frontend_base::middleware_url'),
  $copper_url                           = hiera('profiles::csx_frontend_base::copper_url'),
  $amber_url                            = hiera('profiles::csx_frontend_base::amber_url'),
  $sla_url                              = hiera('profiles::csx_frontend_base::sla_url'),
  $gm_serverstatus_url                  = hiera('profiles::csx_frontend_base::gm_serverstatus_url'),
  $usage_ms_url                         = hiera('profiles::csx_frontend_base::usage_ms_url'),
  $gm_meeting_url                       = hiera('profiles::csx_frontend_base::gm_meeting_url'),
  $quartz_ltr_url                       = hiera('profiles::csx_frontend_base::quartz_ltr_url'),
  $default_idp                          = hiera('profiles::csx_frontend_base::default_idp'),
  $entity_base_url                      = hiera('profiles::csx_frontend_base::entity_base_url'),
  $saml_keystore_password               = hiera('profiles::csx_frontend_base::saml_keystore_password'),
  $saml_keystore_alias                  = hiera('profiles::csx_frontend_base::saml_keystore_alias'),
  $csx_config                           = hiera('profiles::csx_frontend_base::csx_config'),
  $idp                                  = hiera('profiles::csx_frontend_base::idp'),
  $saml_keystore                        = hiera('profiles::csx_frontend_base::saml_keystore'),
  $debug_level                          = hiera('profiles::csx_frontend_base::debug_level'),
  $debug_format                         = hiera('profiles::csx_frontend_base::debug_format'),
  $productization_version               = hiera('profiles::csx_frontend_base::productization_version'),
  $quartz_ltr_job_testsftp              = hiera('profiles::csx_frontend_base::quartz_ltr_job_testsftp'),
  $quartz_ltr_job_testsftp_sourcefolder = hiera('profiles::csx_frontend_base::quartz_ltr_job_testsftp_sourcefolder'),
  $quartz_fe_url                        = hiera('profiles::csx_frontend_base::quartz_fe_url'),
  $kettle_home                          = hiera('profiles::csx_frontend_base::kettle_home '),
  $godeus_home                          = hiera('profiles::csx_frontend_base::godeus_home'),
  $ltr_log_dir                          = hiera('profiles::csx_frontend_base::ltr_log_dir'),
  $etl_properties                       = hiera('profiles::csx_frontend_base::etl_properties'),
  $ltr_reports_dir                      = hiera('profiles::csx_frontend_base::ltr_reports_dir'),
  $nagios_cfg                           = hiera('profiles::csx_frontend_base::nagios_cfg'),
  $mysql_client_version                 = hiera('profiles::csx_frontend_base::mysql_client_version'),
  $nginx_vhost_name                     = hiera('profiles::csx_frontend_base::nginx_vhost_name'),
  $nginx_cert_name                      = hiera('profiles::csx_frontend_base::nginx_cert_name'),
  $nginx_key_name                       = hiera('profiles::csx_frontend_base::nginx_key_name'),
  $nginx_ssl_ciphers                    = hiera('profiles::csx_frontend_base::nginx_ssl_ciphers'),
  ) {

  # Do all pkg config first, kinda a hack but this works so we're doing it.
  stage {'apt-config':
    before => Stage['main']
  }

  # sets up the apt source for connectsolutions on the client
  class { '::profiles::apt_client_config':
    stage => 'apt-config',
  }


  # THIS IS A TOTAL HACK
  # The 'correct' thing to do would be hacking the nginx module to notify the tomcat7 service correctly, or at a later date, using a collector to set a resource default to notify the tomcat7 service from the nginx vhost_autogen.conf. Since we're not going to manage the nginx module, the former is out of the question. However, the latter is doable. 
  stage {'bounce':}
  Stage['main']->Stage['bounce']
  class {'profiles::bounce': stage => 'bounce',}

  # bootstraps the mysql server with fresh data
  # needs to use the same user information as the mysql server setup
  class {'cs_csx_frontend::mysql':
    csx_db_name          => $csx_db_name,
    csx_db_user          => $csx_db_user,
    csx_db_password      => $csx_db_password,
    csx_db_password_hash => $csx_db_password_hash,
    csx_db_host          => $csx_db_host,
    mysql_client_version => $mysql_client_version,
  }

  # installs the productization debian package and ensures related packages (tomcat, default-jdk) are installed
  # also sets up the quartz.properties file, a critical configuration piece for csx_frontend
  # needs to use the same user information as the mysql server setup
  class {'cs_csx_frontend::productization':
    csx_db_name                          => $csx_db_name,
    csx_db_driverclassname               => $csx_db_driverclassname,
    csx_db_url                           => $csx_db_url,
    csx_db_username                      => $csx_db_user,
    csx_db_password                      => $csx_db_password,
    mandrill_apikey                      => $mandrill_apikey,
    mandrill_username                    => $mandrill_username,
    middleware_url                       => $middleware_url,
    copper_url                           => $copper_url,
    amber_url                            => $amber_url,
    sla_url                              => $sla_url,
    gm_serverstatus_url                  => $gm_serverstatus_url,
    usage_ms_url                         => $usage_ms_url,
    gm_meeting_url                       => $gm_meeting_url,
    quartz_ltr_url                       => $quartz_ltr_url,
    default_idp                          => $default_idp,
    entity_base_url                      => $entity_base_url,
    saml_keystore_password               => $saml_keystore_password,
    saml_keystore_alias                  => $saml_keystore_alias,
    debug_level                          => $debug_level,
    debug_format                         => $debug_format,
    csx_config                           => $csx_config,
    idp                                  => $idp,
    saml_keystore                        => $saml_keystore,
    productization_version               => $productization_version,
    quartz_ltr_job_testsftp              => $quartz_ltr_job_testsftp,
    quartz_ltr_job_testsftp_sourcefolder => $quartz_ltr_job_testsftp_sourcefolder,
    quartz_fe_url                        => $quartz_fe_url,
    kettle_home                          => $kettle_home,
    godeus_home                          => $godeus_home,
    ltr_log_dir                          => $ltr_log_dir,
    etl_properties                       => $etl_properties,
    ltr_reports_dir                      => $ltr_reports_dir,
    nagios_cfg                           => $nagios_cfg,
  }

  if $nginx_vhost_name != 'non-nginx'{
    #configures tomcat's server xml by modifying it in place using the puppetlabs tomcat module's server connector defined type
    #modifications add scheme and proxyport attributes to the pre-existing port 8080 connector
    tomcat::config::server::connector { 'tomcat7-http':
      before                => Class['nginx'],
      require               => Class['cs_csx_frontend::productization'],
      catalina_base         => '/var/lib/tomcat7',
      port                  => '8080',
      protocol              => 'HTTP/1.1',
      additional_attributes => {
        'redirectPort' => '8443',
        'proxyPort'    => '443',
        'scheme'       => 'https',
      },
    }

    #installs nginx using the jfryman nginx module
    class { 'nginx':
      require => Class['cs_csx_frontend::productization'],
    }

    #configures nginx vhost for tomcat proxy
    #for SSL certificate chains refer to: http://nginx.org/en/docs/http/configuring_https_servers.html#chains
    nginx::resource::vhost { "${nginx_vhost_name}":
      proxy            => 'http://localhost:8080',
      listen_port      => 443,
      ssl              => true,
      ssl_cert         => "puppet:///filestore/certs/coso/${nginx_cert_name}",
      ssl_key          => "puppet:///filestore/certs/coso/${nginx_key_name}",
      ssl_ciphers      => $nginx_ssl_ciphers,
    }
  }

}
