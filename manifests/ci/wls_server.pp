# == Defined Type: deployit::ci::wls_server
#
# This defined type creates a wls.Server
#
# === Examples
#
# deployit::ci::wls_server { 'Infrastructure/test':
# }
#
# === Parameters
#
# $id - id of the directory (namevar)
#
# $domain_ref - Reference (ID) to the WLS Domain
#
# $port - Listen port
#
# $tags - Array of tags
#
# === Copyright
#
# Copyright (c) 2013, Gemeente Amsterdam, All rights reserved.
#
# === Deployit CI
#
# <wls.Server id="${id}">
#   <tags>
#     <value>${tags}</value>
#   </tags>
#   <port>${port}</port>
#   <domain ref="${domain_ref}"/>
#   <testServerIsRunning>true</testServerIsRunning>
#   <startDelay>5</startDelay>
#   <maxRetries>10</maxRetries>
#   <retryWaitInterval>5</retryWaitInterval>
# </wls.Server>
#
define deployit::ci::wls_server (
  $host_ref,
  $port = 8001,
  $id   = $title,
  $tags = {},
  $domain_ref = deployit_ci_parent_id($title),
) {
  @@deployit_ci { $id:
    type       => 'wls.Server',
    properties => {
      'domain'              => {'@ref'=>$domain_ref},
      'host'                => {'@ref'=>$host_ref},
      'port'                => $port,
      'startDelay'          => 5,
      'maxRetries'          => 10,
      'retryWaitInterval'   => 5,
      'tags'                => $tags,
    }
  }
}
