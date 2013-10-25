# Class deployit::import
#
# imports various exported resources
class deployit::import (
  $rest_url               = $deployit::rest_url,
  $http_server_address    = $deployit::http_server_address,
  $http_port              = $deployit::http_port,
  $use_exported_resources = $deployit::use_exported_resources
) {

  if str2bool($use_exported_resources) {
    deployit_check_connection{'default':
      host => $http_server_address,
      port => $http_port
    }

    -> Deployit_ci <<| |>> {
      rest_url => $rest_url
    }
  }

}
