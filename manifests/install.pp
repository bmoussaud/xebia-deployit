# Class deployit::install
#
# Install the deployit server
class deployit::install (
  $version      = $deployit::version,
  $base_dir     = $deployit::base_dir,
  $tmp_dir      = $deployit::tmp_dir,
  $os_user      = $deployit::os_user,
  $os_group     = $deployit::os_group,
  $install_type = $deployit::install_type
) {

  # Variables
  $server_dir = "${base_dir}/deployit-${version}-server"
  $cli_dir    = "${base_dir}/deployit-${version}-cli"

  case $::osfamily {
    'RedHat' : { $xtra_packages = ['unzip', 'java-1.6.0-openjdk'] }
    default  : { fail("${::osfamily}:${::operatingsystem} not supported by this module") }
  }

  if $::pe_version != undef { $gem_provider = 'pe_gem'} else { $gem_provider = 'gem' }

  # Dependencies
  Group[$os_group]
    -> User[$os_user]
    -> Package[$xtra_packages]
    -> File[ '/var/log/deployit']
    -> File['/etc/init.d/deployit']

  # Resource defaults
  File {
    owner  => $os_user,
    group  => $os_group,
    ensure => present
  }


  # Resources

  #user and group

  group{$os_group:
    ensure => 'present'
  }

  user{$os_user:
    ensure      => present,
    gid         => $os_group ,
    managehome  => true
  }

  package{ $xtra_packages: ensure => present }

  #check to see if where on a redhatty system and shut iptables down quicker than you can say wtf
  case $::osfamily {
    'RedHat' : { service{'iptables': ensure => stopped }

                  Service['iptables']
                    -> File['/etc/deployit', '/var/log/deployit']
              }
    default : {}
  }

  # check the install_type and act accordingly
  case $install_type {
    'puppetfiles' : {
                      $server_zipfile = "deployit-${version}-server.zip"
                      $cli_zipfile    = "deployit-${version}-cli.zip"


                      file {"${tmp_dir}/${server_zipfile}":
                        source => "puppet:///modules/deployit/sources/${server_zipfile}"
                      }

                      file {"${tmp_dir}/${cli_zipfile}":
                        source => "puppet:///modules/deployit/sources/${cli_zipfile}"
                      }

                      file {$base_dir:
                        ensure => directory
                      }

                      file {$server_dir:
                        ensure => directory
                      }

                      file {$cli_dir:
                        ensure => directory
                      }

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

                      Package[$xtra_packages]
                        -> File[$base_dir]
                        -> File[$cli_dir,$server_dir]
                        -> File["${tmp_dir}/${server_zipfile}","${tmp_dir}/${cli_zipfile}"]
                        -> Exec['unpack server file', 'unpack cli file']
                        -> File['/etc/deployit', '/var/log/deployit']
                    }
    'packages'    : { package { ['deployit-server', 'deployit-cli']:
                        ensure => "${version}-jep",
                      }

                      Package['deployit-server', 'deployit-cli']
                        -> File['/etc/deployit', '/var/log/deployit']

                    }
    default       : {}
  }


  package { ['xml-simple', 'rest-client']:
    ensure   => installed,
    provider => $gem_provider,
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


}