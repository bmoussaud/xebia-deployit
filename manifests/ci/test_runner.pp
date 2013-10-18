# == Defined Type: deployit::ci::test_runner
#
# This defined type creates a tests2.TestRunner
#
# === Examples
#
# deployit::ci::test_runner { 'Infrastructure/test':
# }
#
# === Parameters
#
# $id - id of the directory (namevar)
#
# $host_ref - Reference (ID) to the host that runs the admin server for this domain. By default the parent id of $id
#
# $tags - Array of tags
#
# === Copyright
#
# Copyright (c) 2013, Xebia Nederland b.v., All rights reserved.
#
# === Deployit CI
#
# <tests2.TestRunner id="${id}">
#   <tags>
#     <value>${tags}</value>
#   </tags>
#   <host ref="${host_ref}"/>
# </tests2.TestRunner>
#
define deployit::ci::test_runner (
  $host_ref = deployit_ci_parent_id($title),
  $id   = $title,
  $tags = {},
) {
  @@deployit_ci { $id:
    type       => 'tests2.TestRunner',
    properties => {
      'host' => {'@ref'=>$host_ref},
      'tags' => $tags,
    }
  }
}