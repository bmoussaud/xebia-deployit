# Class deployit::params
#
# Default parameters for deployit
#
class deployit::params {
  $version   = '3.9.3'
  $base_dir  = '/opt/deployit'
  $server_home_dir          = "${base_dir}/deployit-server"
  $cli_home_dir             = "${base_dir}/deployit-cli"
  $tmp_dir   = '/var/tmp'
  $server    = true
  $os_user   = 'deployit'
  $os_group  = 'deployit'
  $ssl       = false
  $http_bind_address        = '0.0.0.0'
  $http_server_address      = $::ipaddress_eth1
  $http_port = '4516'
  $http_context_root        = '/deployit'
  $admin_password           = deployit_credentials('admin_password', 'admin')
  $jcr_repository_path      = 'repository'
  $importable_packages_path = 'importablePackages'
  $install_type             = 'puppetfiles'
  $client_sudo              = true
  $client_user_password     = 'deployit'
  $use_exported_resources   = false
  $enable_housekeeping      = true
  $java_home = '/usr/lib/jvm/jre-1.6.0-openjdk.x86_64'
  $install_java             = false
  $install_gems             = true
  $gem_hash  = {
    'xml-simple' => {
    }
    ,
    'restclient' => {
    }
  }

  if str2bool($ssl) {
    $rest_protocol = 'https://'
  } else {
    $rest_protocol = 'http://'
  }

  if $http_context_root == '/' {
    $rest_url = "${rest_protocol}admin:${admin_password}@${http_server_address}:${http_port}/deployit"

  } else {
    $rest_url = "${rest_protocol}admin:${admin_password}@${http_server_address}:${http_port}${http_context_root}/deployit"
  }
}
