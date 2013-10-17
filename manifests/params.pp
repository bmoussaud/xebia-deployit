# Class deployit::params
#
# Default parameters for deployit
#
class deployit::params {
  $base_dir                 = '/opt/deployit'
  $tmp_dir                  = '/var/tmp'
  $os_user                  = 'deployit'
  $os_group                 = 'deployit'
  $ssl                      = false
  $http_bind_address        = '0.0.0.0'
  $http_port                = '4516'
  $http_context_root        = '/deployit'
  $admin_password           = 'admin'
  $jcr_repository_path      = 'repository'
  $importable_packages_path = 'importablePackages'
  $install_type             = 'puppetfiles'
}
