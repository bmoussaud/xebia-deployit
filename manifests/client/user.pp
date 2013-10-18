# == Class: deployit::client::user
#
# This class takes care of the configuration of deployit external nodes
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
class deployit::client::user(
  $os_user              = $deployit::os_user,
  $os_group             = $deployit::os_group,
  $client_sudo          = $deployit::client_sudo,
  $client_user_password = $deployit::client_user_password){

  # Resources

  #user and group

  group{$os_group:
    ensure => 'present'
  }

  user{$os_user:
    ensure      => present,
    gid         => $os_group ,
    managehome  => true,
    password    => md5pass($client_user_password)
  }

  if str2bool($client_sudo) {
    include sudo

    sudoers{$os_user:
      ensure    => present,
      users     => [$os_user],
      commands  => [
        'ALL=(ALL) NOPASSWD: ALL'
      ],
    }
  }



}