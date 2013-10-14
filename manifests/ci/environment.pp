# == Defined Type: deployit::ci::environment
#
# This defined type creates a udm.Environment
#
# === Examples
#
# deployit::ci::environment { 'Environment/test':
# }
#
# === Parameters
#
# $id - id of the environment (namevar)
#
# $members - Array of @ref to Infrastructure CI's, e.g. [{'@ref'=>'Infrastructure/ci_id'},{'@ref'=>'Infrastructure/ci_id2'}]
#
# $dictionaries - Array of @ref to Dictionaries, e.g. [{'@ref'=>'dictionary_id'},{'@ref'=>'dictionary_id2'}]
#
# === Copyright
#
# Copyright (c) 2013, Gemeente Amsterdam, All rights reserved.
#
define deployit::ci::environment (
  $members,
  $dictionaries,
  $id = $title,
) {

  @@deployit_ci { $id:
    type       => 'udm.Environment',
    properties => {
      'members'      => $members,
      'dictionaries' => $dictionaries,
    },
  }
}