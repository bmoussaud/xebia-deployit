# == Defined Type: deployit::ci::wls_trust_keystore
#
# This defined type creates a wls.Domain
#
# === Examples
#
# deployit::ci::wls_trust_keystore { 'Infrastructure/Test/ms1/customTrustKeyStore':
# }
#
# === Parameters
#
# $id - id of the trust keystore (namevar)
#
# $server_ref      - Reference (ID) to the server configured with this trust keystore
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
# <wls.CustomTrustKeyStore id="${id}">
#   <tags/>
#   <server ref="${server_ref}"/>
#   <keystore>/data/weblogic/domains/domainname/trust.jks</keystore>
#   <keystoreType>JKS</keystoreType>
#   <passphrase>{b64}qXnQRx5ATr/ATYTu/ZmVrw==</passphrase>
# </wls.CustomTrustKeyStore>

define deployit::ci::wls_trust_keystore (
  $keystore,
  $passphrase,
  $id            = $title,
  $keystore_type = 'JKS',
  $discovery     = false,
  $tags          = {},
  $server_ref    = deployit_ci_parent_id($title),
) {
  @@deployit_ci { $id:
    type       => 'wls.CustomTrustKeyStore',
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
