# == Defined Type: deployit::ci::oracle_client
#
# This defined type creates a sql.OracleClient
#
# === Examples
#
# deployit::ci::oracle_client { 'Infrastructure/test':
# }
#
# === Parameters
#
# $id - id of the directory (namevar)
#
# $host_ref - Reference (ID) to the host that runs the admin server for this domain
#
# $username - Username to connect to the database with
#
# $password - Password to connect to the database with
#
# $db_host - DB host
#
# $db_port - DB port
#
# $sid - DB SID
#
# $domain - DB domain
#
# $tags - Array of tags
#
# === Copyright
#
# Copyright (c) 2013, Xebia Nederland b.v., All rights reserved.
#
# === Deployit CI
#
# <sql.OracleClient id="${id}">
#   <tags>
#     <value>${tags}</value>
#   </tags>
#   <host ref="${host_ref}"/>
#   <username></username>
#   <password>{b64}OXjDNOGXvhzOsT9lydbeeQ==</password>
#   <oraHome>/opt/oracle/product/11.2/db</oraHome>
#   <sid>//10.251.97.10:1521/MPOT.amsterdam.nl</sid>
# </sql.OracleClient>
#
define deployit::ci::oracle_client (
  $username,
  $password,
  $db_host,
  $sid,
  $db_port  = 1521,
  $domain   = 'amsterdam.nl',
  $id       = $title,
  $tags     = {},
  $host_ref = deployit_ci_parent_id($title),
) {
  @@deployit_ci { $id:
    type       => 'sql.OracleClient',
    properties => {
      'host'     => {'@ref'=>$host_ref},
      'username' => $username,
      'password' => $password,
      'oraHome'  => '/opt/oracle/product/11.2/db',
      'sid'      => "//${db_host}:${db_port}/${sid}.${domain}",
      'tags'     => $tags,
    }
  }
}