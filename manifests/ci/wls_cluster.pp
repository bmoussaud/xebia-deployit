# == Defined Type: deployit::ci::wls_cluster
#
# This defined type creates a wls.Cluster
#
# === Examples
#
# deployit::ci::wls_cluster { 'Infrastructure/test':
# }
#
# === Parameters
#
# $id - id of the directory (namevar)
#
# $domain_ref - Reference (ID) to the WLS Domain
#
# $server_refs - Array of server refs [{'@ref'=>'<server_1_id>'}, {'@ref'=>'<server_2_id>'}]
#
# $tags - Array of tags
#
# === Copyright
#
# Copyright (c) 2013, Gemeente Amsterdam, All rights reserved.
#
# === Deployit CI
#
# <wls.Cluster id="${id}">
#   <tags>
#     <value>${tags}</value>
#   </tags>
#   <domain ref="${domain_ref}"/>
#   <servers>
#     <ci ref="${server_ref}"/>
#   </servers>
# </wls.Cluster>
#
define deployit::ci::wls_cluster (
  $domain_ref  = deployit_ci_parent_id($title),
  $id          = $title,
  $tags        = {},
) {

  @@deployit_ci { $id:
    type       => 'wls.Cluster',
    properties => {
      'domain'  => {'@ref'=>$domain_ref},
      'tags'    => $tags,
    }
  }
}
