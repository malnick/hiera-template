# profile for csx_copper
# configures an ubuntu machine to deploy the csx_copper
class profiles::csx_copper(
# Copper service config
  $copper_config       = hiera('profiles::csx_copper::copper_config'),
  $force_auth_endpoint = hiera('profiles::csx_copper::force_auth_endpoint'), 
  $force_username      = hiera('profiles::csx_copper::force_username'),
  $force_password      = hiera('profiles::csx_copper::force_password'),
  $debug_level         = hiera('profiles::csx_copper::debug_level'),
  $debug_format        = hiera('profiles::csx_copper::debug_format'),
  $catalina_base       = hiera('profiles::csx_copper::catalina_base'),
  $catalina_home       = hiera('profiles::csx_copper::catalina_home'), 
  $reloadable          = hiera('profiles::csx_copper::reloadable'),
  $webapp_dir          = hiera('profiles::csx_copper::webapp_dir'),
  $max_perm_size       = hiera('profiles::csx_copper::max_perm_size'), 
  $copper_version      = hiera('profiles::csx_copper::copper_version'), 
  ) {

  class {'cs_csx_copper':
    copper_config       => $copper_config,
    force_auth_endpoint => $force_auth_endpoint,
    force_username      => $force_username,
    force_password      => $force_password,
    debug_level         => $debug_level,
    debug_format        => $debug_format,
    catalina_base       => $catalina_base,
    catalina_home       => $catalina_home,
    reloadable          => $reloadable,
    webapp_dir          => $webapp_dir,
    max_perm_size       => $max_perm_size,
    copper_version      => $copper_version,
  }

}
