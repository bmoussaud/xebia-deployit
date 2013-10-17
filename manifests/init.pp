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
# Copyright (c) 2013, Gemeente Amsterdam, All rights reserved.
#
class deployit (
  $version,
  $base_dir                 = $deployit::params::base_dir,
  $tmp_dir                  = $deployit::params::tmp_dir,
  $os_user                  = $deployit::params::os_user,
  $os_group                 = $deployit::params::os_group,
  $ssl                      = $deployit::params::ssl,
  $http_bind_address        = $deployit::params::http_bind_address,
  $http_port                = $deployit::params::http_port,
  $http_context_root        = '/',
  $admin_password           = $deployit::params::admin_password,
  $jcr_repository_path      = $deployit::params::jcr_repository_path,
  $importable_packages_path = $deployit::params::importable_packages_path,
) inherits deployit::params {

  # Variables

  # include deployit::messages

  anchor { 'deployit::begin': }
    -> class { 'deployit::install': }
    -> class { 'deployit::utils': }
    -> class { 'deployit::config': }
    ~> class { 'deployit::service': }
    -> anchor { 'deployit::end': }
}
