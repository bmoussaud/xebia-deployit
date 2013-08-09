# == Defined Type: deployit::ci::host
#
# This defined type creates a overthere.SshHost
#
# === Examples
#
# deployit::ci::host { 'Infrastructure/test/test-host':
# }
#
# === Parameters
#
# $id - id of the directory (namevar)
#
# $username - username to connect with
# 
# $address - Address of the host, defaults to $ipaddress
# 
# $tags - Array of tags, defaults to empty array []
# 
# === Copyright
#
# Copyright (c) 2013, Gemeente Amsterdam, All rights reserved.
#
define deployit::ci::host (
  $username,
  $id              = $title,
  $address         = $ipaddress,
  $tags            = [],
) {

  @@deployit_ci { $id:
    type => 'overthere.SshHost',
    properties => {
      'address'                => [$address],
      'connectionType'         => ['SUDO'],
      'os'                     => ['UNIX'],
      'port'                   => [22],
      'username'               => [$username],
      'temporaryDirectoryPath' => ['/var/tmp'],
      'tags'                   => [{'value'=>$tags}]
    }
  }
}