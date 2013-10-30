# Class deployit::import
#
# imports various exported resources
class deployit::import (
  $rest_url               = $deployit::rest_url,
  $http_server_address    = $deployit::http_server_address,
  $http_port              = $deployit::http_port,
  $use_exported_resources = $deployit::use_exported_resources,
  $server_cis             = $deployit::server_cis
) {

  Deployit_check_connection['default']
  -> deployit_ci[keys($server_cis)]


  Deployit_ci{ rest_url => $rest_url }

  create_resources(deployit_ci, $server_cis)

  deployit_check_connection{'default':
      host => $http_server_address,
      port => $http_port
    }

  if str2bool($use_exported_resources) {

    Deployit_check_connection['default']

    -> Deployit_ci <<| |>> {
      rest_url => $rest_url
    }
  }

}
