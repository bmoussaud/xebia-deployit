# Class deployit::install
#
# Install the deployit server
class deployit::install (
  $version  = $deployit::version,
  $base_dir = $deployit::base_dir,
  $tmp_dir  = $deployit::tmp_dir,
  $os_user  = $deployit::os_user,
  $os_group = $deployit::os_group,
) {

  # Variables
  $server_dir = "${base_dir}/deployit-${version}-server"

  # Dependencies
  Package['deployit-server', 'deployit-cli']
    -> File['/etc/deployit', '/var/log/deployit']
    -> File['/etc/init.d/deployit']

  # Resource defaults
  File {
    owner  => $os_user,
    group  => $os_group,
    ensure => present
  }

  # Resources
  package { ['deployit-server', 'deployit-cli']:
    ensure => installed,
  }

  package { ['xml-simple', 'rest-client']:
    ensure   => installed,
    provider => 'pe_gem',
  }

  # convenience links
  file { '/etc/deployit':
    ensure => link,
    target => "${server_dir}/conf";
  }

  file { '/var/log/deployit':
    ensure => link,
    target => "${server_dir}/log";
  }

  # put the init script in place
  # the template uses the following variables:
  # @os_user
  # @server_dir
  file { '/etc/init.d/deployit':
    content => template('deployit/deployit.initd.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0700'
  }

  include apache
  apache::conf { 'deploy.jep.amsterdam.nl.conf':
    content => template('deployit/deploy.jep.amsterdam.nl.conf.erb'),
  }
}