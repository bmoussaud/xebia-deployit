# == Defined Type: deployit::ci::apache_httpd
#
# This defined type creates a www.ApacheHttpdServer
#
# === Examples
#
# deployit::ci::apache_httpd { 'Infrastructure/test':
# }
#
# === Parameters
#
# $id - id of the directory (namevar)
#
# $host_ref - Reference (ID) to the host that runs the admin server for this domain. By default the parent id of $id
#
# $conf_dir - The directory in which the configuration fragments must be written. By default ${conf_bas_dir}/${conf_sub_dir}
#
# $conf_base_dir - The base directory in which the configuration fragments must be written. By default /etc/httpd/conf.d
#
# $conf_sub_dir - The directory under ${conf_base_dir} in which the configuration fragments must be written. By default {ci_name}
#
# $tags - Array of tags
#
# === Copyright
#
# Copyright (c) 2013, Xebia Nederland b.v., All rights reserved.
#
# === Deployit CI
#
# <www.ApacheHttpdServer id="${id}">
#     <tags>
#         <value>${tags}</value>
#     </tags>
#     <host ref="${host_ref}"/>
#     <startCommand>/sbin/service httpd start</startCommand>
#     <startWaitTime>10</startWaitTime>
#     <stopCommand>/sbin/service httpd stop</stopCommand>
#     <stopWaitTime>10</stopWaitTime>
#     <restartCommand>/sbin/service httpd graceful</restartCommand>
#     <restartWaitTime>3</restartWaitTime>
#     <defaultDocumentRoot>/var/www/html</defaultDocumentRoot>
#     <configurationFragmentDirectory>${conf_dir}</configurationFragmentDirectory>
# </www.ApacheHttpdServer>
#
define deployit::ci::apache_httpd (
  $host_ref      = deployit_ci_parent_id($title),
  $conf_base_dir = '/etc/httpd/conf.d',
  $conf_sub_dir  = deployit_ci_name($title),
  $id            = $title,
  $tags          = {},
) {
  $conf_dir = "${conf_base_dir}/${conf_sub_dir}"

  @@deployit_ci { $id:
    type       => 'www.ApacheHttpdServer',
    properties => {
      'host'                           => {'@ref'=>$host_ref},
      'startCommand'                   => '/sbin/service httpd start',
      'startWaitTime'                  => 10,
      'stopCommand'                    => '/sbin/service httpd stop',
      'stopWaitTime'                   => 10,
      'restartCommand'                 => '/sbin/service httpd reload || /sbin/service httpd restart ',
      'restartWaitTime'                => 3,
      'defaultDocumentRoot'            => '/var/www/html',
      'configurationFragmentDirectory' => $conf_dir,
      'tags'                           => $tags,
    }
  }
}
