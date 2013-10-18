# == Class: deployit
#
# This class installs Deployit
#
# === Examples
#
#  class { 'deployit':
#  }
#
# === Parameters
#
#
# === Copyright
#
# Copyright (c) 2013, Xebia Nederland b.v., All rights reserved.
#
class deployit (
  $version                  = $deployit::params::version,
  $base_dir                 = $deployit::params::base_dir,
  $tmp_dir                  = $deployit::params::tmp_dir,
  $server                   = $deployit::params::server,
  $os_user                  = $deployit::params::os_user,
  $os_group                 = $deployit::params::os_group,
  $ssl                      = $deployit::params::ssl,
  $http_bind_address        = $deployit::params::http_bind_address,
  $http_port                = $deployit::params::http_port,
  $http_context_root        = $deployit::params::http_context_root,
  $http_server_address      = $deployit::params::http_server_address,
  $admin_password           = $deployit::params::admin_password,
  $jcr_repository_path      = $deployit::params::jcr_repository_path,
  $importable_packages_path = $deployit::params::importable_packages_path,
  $client_sudo              = $deployit::params::client_sudo,
  $client_user_password     = $deployit::params::client_user_password,
  $install_type             = $deployit::params::install_type,
  $rest_url                 = $deployit::params::rest_url,
  $export_resources         = $deployit::params::export_resources,
  $client_cis               = { }
) inherits deployit::params {

  #include validation class to check our input
  include validation

  # Variables



  # include deployit::messages
  if str2bool($server) {
    anchor { 'deployit::begin': }
      -> class { 'deployit::install': }
      -> class { 'deployit::utils': }
      -> class { 'deployit::config': }
      ~> class { 'deployit::service': }
      -> anchor { 'deployit::end': }
  }
  else
  {
    anchor { 'deployit::begin': }
      -> class{ 'deployit::client::user':}
      -> class{ 'deployit::client::config':}
    anchor { 'deployit::end': }
  }

}
