# == Defined Type: deployit::ci::directory
#
# This defined type creates a core.Directory
#
# === Examples
#
# deployit::ci::directory { 'Infrastructure/test':
# }
#
# === Parameters
#
# $id - id of the directory (namevar)
#
# === Copyright
#
# Copyright (c) 2013, Xebia Nederland b.v., All rights reserved.
#
define deployit::ci::directory (
  $id = $title,
) {

  @@deployit_ci { $id:
    type       => 'core.Directory',
    properties => {},
  }
}