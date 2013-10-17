# == Defined Type: deployit::ci::dictionary
#
# This defined type creates a udm.Dictionary
#
# === Examples
#
# deployit::ci::dictionary { 'Environment/test':
# }
#
# === Parameters
#
# $id - id of the dictionary (namevar)
#
# $entries - hash of entries, optional
#
# $encrypted - boolean, indicating whether dictionary is encrypted, default false
#
# === Copyright
#
# Copyright (c) 2013, Gemeente Amsterdam, All rights reserved.
#
# === Deployit CI
#
# <udm.Dictionary id="${id}">
#   <entries>
#     <entry key="${entries[i].key}">${entries[i].value}</entry>
#   </entries>
# </udm.Dictionary>
#
define deployit::ci::dictionary (
  $id        = $title,
  $entries   = undef,
  $encrypted = false,
) {

  if $encrypted {
    $type = 'udm.EncryptedDictionary'
  }
  else {
    $type = 'udm.Dictionary'
  }

  if $entries == undef {
    @@deployit_ci { $id:
      type       => $type,
      properties => {},
    }
  }
  else {
    @@deployit_ci { $id:
      type       => $type,
      properties => {
        'entries' => $entries,
      },
    }
  }
}