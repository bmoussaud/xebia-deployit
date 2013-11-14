# Class deployit::install
#
# Install the deployit server
class deployit::housekeeping (
  $os_user         = $deployit::os_user,
  $os_group        = $deployit::os_group,
  $server_home_dir = $deployit::server_home_dir,
  $cli_home_dir    = $deployit::cli_home_dir,
  $http_port       = $deployit::http_port) {
  file { "${server_home_dir}/scripts/deployit-housekeeping.sh":
    ensure  => present,
    content => template('deployit/deployit-housekeeping.sh.erb'),
    mode    => '0744',
  }

  file { "${server_home_dir}/scripts/garbage-collector.py": ensure => absent, }

  file { "${server_home_dir}/scripts/housekeeping.py":
    ensure => present,
    source => 'puppet:///deployit/scripts/housekeeping.py',
  }

  cron { 'deployit-housekeeping':
    ensure  => present,
    command => "${server_home_dir}/scripts/deployit-housekeeping.sh",
    user    => root,
    hour    => 2,
    minute  => 5,
  }

}
