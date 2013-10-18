# == Class: deployit::client::config
#
# This class takes care of the configuration of deployit external nodes
# === Examples
#
#
#
# === Parameters
#
#
# === Copyright
#
# Copyright (c) 2013, Xebia Nederland b.v., All rights reserved.
#
class deployit::client::config(
  $rest_url         = $deployit::rest_url,
  $client_cis       = $deployit::client_cis,
  $export_resources = $deployit::export_resources ){

  # overwrite the rest_url parameter
  Deployit_ci{rest_url => $rest_url}

  # create all the ci's specified in the $client_cis varialbe
  if str2bool($export_resources) {
    create_resources('@@deployit_ci', $client_cis)
  } else {
    create_resources(deployit_ci, $client_cis)
  }
}