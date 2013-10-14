# == Defined Type: deployit::ci::wls_identity_keystore
#
# This defined type creates a wls.Domain
#
# === Examples
#
# deployit::ci::wls_identity_keystore { 'Infrastructure/Test/ms1/customIdentityKeyStore':
# }
#
# === Parameters
#
# $id - id of the identity keystore (namevar)
#
# $server_ref      - Reference (ID) to the server configured with this identity keystore
#
# $keystore        - Absolute path of the keystore
#
# $keystore_type   - Type of the keystore (default JKS)
#
# $passphrase - Passphrase of the keystore
#
# $tags - Array of tags
#
# === Copyright
#
# Copyright (c) 2013, Gemeente Amsterdam, All rights reserved.
#
# === Deployit CI
#
# <wls.CustomIdentityKeyStore id="${id}">
#   <tags/>
#   <server ref="${server_ref}"/>
#   <keystore>/data/weblogic/domains/domainname/identity.jks</keystore>
#   <keystoreType>JKS</keystoreType>
#   <passphrase>{b64}qXnQRx5ATr/ATYTu/ZmVrw==</passphrase>
# </wls.CustomIdentityKeyStore>

define deployit::ci::wls_identity_keystore (
  $keystore,
  $passphrase,
  $id            = $title,
  $keystore_type = 'JKS',
  $discovery     = false,
  $tags          = {},
  $server_ref    = deployit_ci_parent_id($title),
) {
  @@deployit_ci { $id:
    type       => 'wls.CustomIdentityKeyStore',
    discovery  => $discovery,
    properties => {
      'server'          => {'@ref'=>$server_ref},
      'keystore'        => $keystore,
      'keystoreType'    => $keystore_type,
      'passphrase'      => $passphrase,
      'tags'            => $tags,
    }
  }
}
