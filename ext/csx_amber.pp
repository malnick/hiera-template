# profile for csx_amber
# configures an ubuntu machine to deploy the csx_amber
class profiles::csx_amber(
  # Amber service config
  $amber_config           = hiera('profiles::csx_amber::amber_config'),
  $amber_webapp_dir       = hiera('profiles::csx_amber::amber_webapp_dir'),
  $csx_db_driverclassname = hiera('profiles::csx_amber::csx_db_driverclassname'),
  $amber_db_url           = hiera('profiles::csx_amber::amber_db_url'),
  $amber_db_host          = hiera('profiles::csx_amber::amber_db_host'),
  $amber_db_name          = hiera('profiles::csx_amber::amber_db_name'),
  $amber_db_user          = hiera('profiles::csx_amber::amber_db_user'),
  $amber_db_password_hash = hiera('profiles::csx_amber::amber_db_password_hash'),
  $amber_db_password      = hiera('profiles::csx_amber::amber_db_password'),
  $mandrill_username      = hiera('profiles::csx_amber::mandrill_username'), 
  $mandrill_apikey        = hiera('profiles::csx_amber::mandrill_apikey'), 
  $debug_level            = hiera('profiles::csx_amber::debug_level'),
  $debug_format           = hiera('profiles::csx_amber::debug_format'),
  $catalina_base          = hiera('profiles::csx_amber::catalina_base'),
  $catalina_home          = hiera('profiles::csx_amber::catalina_home'),
  $reloadable             = hiera('profiles::csx_amber::reloadable'),
  $max_perm_size          = hiera('profiles::csx_amber::max_perm_size'),
  $amber_version          = hiera('profiles::csx_amber::amber_version'),
  $mysql_client_version   = hiera('profiles::csx_amber::mysql_client_version'),
  $process_notif_url      = hiera('profiles::csx_amber::process_notif_url'),
  ) {

    # bootstraps the mysql server with fresh data
  # needs to use the same user information as the mysql server setup
  class {'cs_csx_amber::mysql':
    amber_db_name          => $amber_db_name,
    amber_db_user          => $amber_db_user,
    amber_db_password      => $amber_db_password,
    amber_db_password_hash => $amber_db_password_hash,
    amber_db_host          => $amber_db_host,
    mysql_client_version   => $mysql_client_version,
  }->
  class {'cs_csx_amber':
    amber_config           => $amber_config,
    csx_db_driverclassname => $csx_db_driverclassname,
    amber_db_url           => $amber_db_url,
    amber_db_user          => $amber_db_user,
    amber_db_password      => $amber_db_password,
    mandrill_username      => $mandrill_username,
    mandrill_apikey        => $mandrill_apikey,
    debug_level            => $debug_level,
    debug_format           => $debug_format,
    catalina_base          => $catalina_base,
    catalina_home          => $catalina_home,
    reloadable             => $reloadable,
    webapp_dir             => $amber_webapp_dir,
    max_perm_size          => $max_perm_size,
    amber_version          => $amber_version,
    process_notif_url      => $process_notif_url,
  }

}
