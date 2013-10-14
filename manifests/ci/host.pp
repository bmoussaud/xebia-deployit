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
# === Deployit CI
#
# <overthere.SshHost id="${id}">
#   <tags>
#     <value>${tags}</value>
#   </tags>
#   <os>UNIX</os>
#   <temporaryDirectoryPath>/var/tmp</temporaryDirectoryPath>
#   <connectionType>SUDO</connectionType>
#   <address>${address}</address>
#   <port>22</port>
#   <username>${username}</username>
#   <privateKeyFile>/home/${username}/.ssh/id_rsa</privateKeyFile>
#   <sudoUsername>root</sudoUsername>
# </overthere.SshHost>
#
define deployit::ci::host (
  $username = 'deployit',
  $id      = $title,
  $address = $ipaddress,
  $tags    = {},
) {

  @@deployit_ci { $id:
    type       => 'overthere.SshHost',
    properties => {
      'address'                => $address,
      'connectionType'         => 'SUDO',
      'os'                     => 'UNIX',
      'port'                   => 22,
      'username'               => $username,
      'sudoUsername'           => 'root',
      'privateKeyFile'         => "/home/${username}/.ssh/id_rsa",
      'temporaryDirectoryPath' => '/var/tmp',
      'tags'                   => $tags,
    }
  }
}