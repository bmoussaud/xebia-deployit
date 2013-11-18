# Class deployit::utils
#
# Install deployit utils
class deployit::utils (
  $base_dir = $deployit::base_dir,
  $version  = $deployit::version,
  $os_user  = $deployit::os_user,
  $os_group = $deployit::os_group,) {
  # Variables
  $server_dir = "${base_dir}/deployit-${version}-server"
  $cli_dir    = "${base_dir}/deployit-${version}-cli"
  $utils_dir  = "${base_dir}/utils"

  # Dependencies

  # Resource defaults
  File {
    owner => $os_user,
    group => $os_group,
  }

  # Resources
  file { $utils_dir: ensure => directory, }

  file { "${utils_dir}/password-encrypt.jar":
    ensure => present,
    source => "puppet:///modules/${module_name}/utils/password-encrypt.jar",
  }

  file { "${utils_dir}/password-encrypt-logback.xml":
    ensure => present,
    source => "puppet:///modules/${module_name}/utils/password-encrypt-logback.xml"
  }

  file { "${utils_dir}/password-encrypt.sh":
    ensure  => present,
    content => template('deployit/password-encrypt.sh.erb'),
    mode    => '0750',
  }

  file { "${utils_dir}/init-app.py":
    ensure => present,
    source => "puppet:///modules/${module_name}/utils/init-app.py",
  }

  file { "${utils_dir}/init-app.sh":
    ensure  => present,
    content => template('deployit/init-app.sh.erb'),
    mode    => '0750',
  }

}
