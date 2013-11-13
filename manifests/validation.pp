# == Class: deployit:validation
#
# This class installs Deployit
#
# === Examples
#
#
#
# === Parameters
#
#
# === Copyright
#
# Copyright (c) 2013, Xebia Nederland b.v., All rights reserved.
#
class deployit::validation (
) {
  # # type validations
  # string validation
  validate_string($deployit::version)
  validate_string($deployit::os_user)
  validate_string($deployit::os_group)
  validate_string($deployit::admin_password)
  validate_string($deployit::jcr_repository_path)
  validate_string($deployit::importable_packages_path)
  validate_string($deployit::client_user_password)

  # path validation
  validate_absolute_path($deployit::base_dir)
  validate_absolute_path($deployit::server_home_dir)
  validate_absolute_path($deployit::cli_home_dir)
  validate_absolute_path($deployit::tmp_dir)
  validate_absolute_path($deployit::http_context_root)

  # ipadress validation
  validate_ipv4_address($deployit::http_bind_address)

  # boolean validation
  validate_bool(str2bool($deployit::server))
  validate_bool(str2bool($deployit::ssl))
  validate_bool(str2bool($deployit::client_sudo))
  validate_bool(str2bool($deployit::export_resources))
  validate_bool(str2bool($deployit::enable_housekeeping))
  # hash validation
  validate_hash($deployit::client_cis)

  # # contence validation
  # check validity of this module on the specific system
  case $::osfamily {
    'RedHat' : { }
    default  : { fail("operating system ${::operatingsystem} not supported") }
  }

  case $deployit::install_type {
    'puppetfiles' : {
    }
    'packages'    : {
    }
    default       : {
      fail("unsupported install_type parameter ${deployit::install_type} specified, should be one of: [puppetfiles, packages]")
    }
  }

}
