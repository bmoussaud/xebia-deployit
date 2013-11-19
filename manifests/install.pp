# Class deployit::install
#
# Install the deployit server
class deployit::install (
  $version         = $deployit::version,
  $base_dir        = $deployit::base_dir,
  $tmp_dir         = $deployit::tmp_dir,
  $os_user         = $deployit::os_user,
  $os_group        = $deployit::os_group,
  $install_type    = $deployit::install_type,
  $server_home_dir = $deployit::server_home_dir,
  $cli_home_dir    = $deployit::cli_home_dir,
  $install_java    = $deployit::install_java,
  $java_home       = $deployit::java_home) {
  # Variables
  $server_dir = "${base_dir}/deployit-${version}-server"
  $cli_dir    = "${base_dir}/deployit-${version}-cli"

  # Dependencies
  Group[$os_group] -> User[$os_user] -> File['/var/log/deployit'] -> File['/etc/init.d/deployit'] -> File[$server_home_dir] -> File[
    $cli_home_dir] -> File["${server_home_dir}/scripts"]

  # Resource defaults
  File {
    owner  => $os_user,
    group  => $os_group,
    ensure => present
  }

  # Resources
  case $::osfamily {
    'RedHat' : {
      $xtra_packages = ['unzip']
      User[$os_user] -> Package[$xtra_packages] -> File['/var/log/deployit']

      package { $xtra_packages: ensure => present }
    }
    default  : {
      fail("${::osfamily}:${::operatingsystem} not supported by this module")
    }
  }

  if str2bool($install_java) {
    case $::osfamily {
      'RedHat' : {
        $java_packages = ['java-1.6.0-openjdk']
        User[$os_user] -> Package[$java_packages] -> File['/var/log/deployit']

        package { $java_packages: ensure => present }
      }
      default  : {
        fail("${::osfamily}:${::operatingsystem} not supported by this module")
      }
    }
  }

  # user and group

  group { $os_group: ensure => 'present' }

  user { $os_user:
    ensure     => present,
    gid        => $os_group,
    managehome => true
  }

  # check to see if where on a redhatty system and shut iptables down quicker than you can say wtf
  case $::osfamily {
    'RedHat' : {
      service { 'iptables': ensure => stopped }

      Service['iptables'] -> File['/etc/deployit', '/var/log/deployit']
    }
    default  : {
    }
  }

  # check the install_type and act accordingly
  case $install_type {
    'puppetfiles' : {
      $server_zipfile = "deployit-${version}-server.zip"
      $cli_zipfile    = "deployit-${version}-cli.zip"

      file { "${tmp_dir}/${server_zipfile}": source => "puppet:///modules/deployit/sources/${server_zipfile}" }

      file { "${tmp_dir}/${cli_zipfile}": source => "puppet:///modules/deployit/sources/${cli_zipfile}" }

      file { $base_dir: ensure => directory }

      file { $server_dir: ensure => directory }

      file { $cli_dir: ensure => directory }

      exec { 'unpack server file':
        command => "/usr/bin/unzip ${tmp_dir}/${server_zipfile};
                                    /bin/cp -rp ${tmp_dir}/deployit-${version}-server/* \
                                    ${server_dir}",
        creates => "${server_dir}/bin",
        cwd     => $tmp_dir,
        user    => $os_user
      }

      # ... and cli packages
      exec { 'unpack cli file':
        command => "/usr/bin/unzip ${tmp_dir}/${cli_zipfile};
                                    /bin/cp -rp ${tmp_dir}/deployit-${version}-cli/* \
                                    ${cli_dir}",
        creates => "${cli_dir}/bin",
        cwd     => $tmp_dir,
        user    => $os_user
      }

      Package[$xtra_packages] -> File[$base_dir] -> File[$cli_dir, $server_dir] -> File["${tmp_dir}/${server_zipfile}", "${tmp_dir}/${cli_zipfile}"
        ] -> Exec['unpack server file', 'unpack cli file'] -> File['/etc/deployit', '/var/log/deployit']
    }
    'packages'    : {
      package { [
        'deployit-server',
        'deployit-cli']: ensure => "${version}-jep", }

      Package['deployit-server', 'deployit-cli'] -> File['/etc/deployit', '/var/log/deployit']

    }
    default       : {
    }
  }

  # convenience links


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

  # setup homedir
  file { $server_home_dir:
    ensure => link,
    target => $server_dir,
    owner  => $os_user,
    group  => $os_group
  }

  file { $cli_home_dir:
    ensure => link,
    target => $cli_dir,
    owner  => $os_user,
    group  => $os_group
  }

  file { "${server_home_dir}/scripts":
    ensure => directory,
    owner  => $os_user,
    group  => $os_group
  }
}
