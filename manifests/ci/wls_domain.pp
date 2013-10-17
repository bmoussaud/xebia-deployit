# == Defined Type: deployit::ci::wls_domain
#
# This defined type creates a wls.Domain
#
# === Examples
#
# deployit::ci::wls_domain { 'Infrastructure/test':
# }
#
# === Parameters
#
# $id - id of the directory (namevar)
#
# $host_ref - Reference (ID) to the host that runs the admin server for this domain
#
# $password - Admin password
#
# $tags - Array of tags
#
# === Copyright
#
# Copyright (c) 2013, Gemeente Amsterdam, All rights reserved.
#
# === Deployit CI
#
# <wls.Domain id="${id}">
#   <tags>
#     <value>${tags}</value>
#   </tags>
#   <host ref="${host_ref}"/>
#   <version>WEBLOGIC_12</version>
#   <wlHome>/opt/weblogic/wlserver_12.1</wlHome>
#   <port>7001</port>
#   <username>weblogic</username>
#   <password>${password}</password>
#   <protocol>t3</protocol>
#   <adminServerName>AdminServer</adminServerName>
#   <startMode>NodeManager</startMode>
# </wls.Domain>
#
define deployit::ci::wls_domain (
  $host_ref,
  $password,
  $version   = 'WEBLOGIC_12',
  $id        = $title,
  $discovery = false,
  $tags      = {},
) {
  @@deployit_ci { $id:
    type       => 'wls.Domain',
    discovery  => $discovery,
    properties => {
      'protocol'        => 't3',
      'host'            => {'@ref'=>$host_ref},
      'port'            => '7001',
      'username'        => 'weblogic',
      'password'        => $password,
      'version'         => $version,
      'wlHome'          => '/opt/weblogic/wlserver_12.1',
      'adminServerName' => 'AdminServer',
      'startMode'       => 'NodeManager',
      'tags'            => $tags,
    }
  }
}
