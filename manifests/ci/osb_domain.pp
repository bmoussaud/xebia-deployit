# == Defined Type: deployit::ci::osb_domain
#
# This defined type creates a osb.Domain
#
# === Examples
#
# deployit::ci::osb_domain { 'Infrastructure/test':
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
# Copyright (c) 2013, Xebia Nederland b.v., All rights reserved.
#
# === Deployit CI
#
# <osb.Domain id="${id}">
#   <tags>
#     <value>${tags}</value>
#   </tags>
#   <host ref="${host}"/>
#   <version>WEBLOGIC_11</version>
#   <wlHome>/opt/osb/wlserver_10.3</wlHome>
#   <port>7001</port>
#   <username>weblogic</username>
#   <password>${password}</password>
#   <protocol>t3</protocol>
#   <adminServerName>AdminServer</adminServerName>
#   <startMode>NodeManager</startMode>
#   <osbHome>/opt/osb/Oracle_OSB</osbHome>
# </osb.Domain>
#
define deployit::ci::osb_domain (
  $host_ref,
  $password,
  $version   = 'WEBLOGIC_11',
  $id        = $title,
  $discovery = false,
  $tags      = {},
) {
  @@deployit_ci { $id:
    type       => 'osb.Domain',
    discovery  => $discovery,
    properties => {
      'protocol'        => 't3',
      'host'            => {'@ref'=>$host_ref},
      'port'            => '7001',
      'username'        => 'weblogic',
      'password'        => $password,
      'version'         => $version,
      'wlHome'          => '/opt/osb/wlserver_10.3',
      'osbHome'         => '/opt/osb/Oracle_OSB',
      'adminServerName' => 'AdminServer',
      'startMode'       => 'NodeManager',
      'tags'            => $tags,
    }
  }
}
