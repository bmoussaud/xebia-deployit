# Class deployit::config
#
# This class handles the configuration of the deployit server
class deployit::config (
  $version   = $deployit::version,
  $base_dir  = $deployit::base_dir,
  $os_user   = $deployit::os_user,
  $os_group  = $deployit::os_group,
  $ssl       = $deployit::ssl,
  $http_bind_address        = $deployit::http_bind_address,
  $http_port = $deployit::http_port,
  $http_context_root        = $deployit::http_context_root,
  $admin_password           = $deployit::admin_password,
  $jcr_repository_path      = $deployit::jcr_repository_path,
  $importable_packages_path = $deployit::importable_packages_path,
  $java_home = $deployit::java_home) {
  # Variables
  $server_dir = "${base_dir}/deployit-${version}-server"
  $cli_dir    = "${base_dir}/deployit-${version}-cli"

  # Dependencies
  File["${server_dir}/conf/deployit.conf", 'deployit server plugins', 'deployit server default properties', 'deployit server ext', 'deployit server hotfix', 'deployit cli ext', '/etc/deployit'
    ] -> Ini_setting['deployit.http.port', 'deployit.jcr.repository.path', 'deployit.ssl', 'deployit.http.bind.address', 'deployit.http.context.root', 'deployit.importable.packages.path', 'deployit.admin.password'
    ] -> Exec['init deployit']

  # Resource defaults
  File {
    owner  => $os_user,
    group  => $os_group,
    ensure => present,
    mode   => '0640',
    ignore => '.gitkeep'
  }

  Ini_setting {
    path    => "${server_dir}/conf/deployit.conf",
    ensure  => present,
    section => '',
  }

  # Resources
  file { "${server_dir}/conf/deployit.conf": }

  file { 'deployit server default properties':
    source  => 'puppet:///modules/deployit/server-conf/',
    recurse => true,
    path    => "${server_dir}/conf",
  }

  file { 'deployit server plugins':
    source       => [
      'puppet:///modules/deployit/plugins/',
      "${server_dir}/available-plugins"],
    sourceselect => 'all',
    recurse      => true,
    purge        => true,
    path         => "${server_dir}/plugins",
  }

  file { 'deployit server hotfix':
    source  => 'puppet:///modules/deployit/hotfix/',
    recurse => true,
    purge   => true,
    path    => "${server_dir}/hotfix",
  }

  file { 'deployit server ext':
    source  => 'puppet:///modules/deployit/server-ext/',
    recurse => 'remote',
    path    => "${server_dir}/ext",
  }

  file { 'deployit cli ext':
    source  => 'puppet:///modules/deployit/cli-ext/',
    recurse => 'remote',
    path    => "${cli_dir}/ext",
  }

  ini_setting {
    'deployit.admin.password':
      setting => 'admin.password',
      value   => $admin_password;

    'deployit.http.port':
      setting => 'http.port',
      value   => $http_port;

    'deployit.jcr.repository.path':
      setting => 'jcr.repository.path',
      value   => $jcr_repository_path;

    'deployit.ssl':
      setting => 'ssl',
      value   => $ssl;

    'deployit.http.bind.address':
      setting => 'http.bind.address',
      value   => $http_bind_address;

    'deployit.http.context.root':
      setting => 'http.context.root',
      value   => $http_context_root;

    'deployit.importable.packages.path':
      setting => 'importable.packages.path',
      value   => $importable_packages_path;
  }

  exec { 'init deployit':
    creates     => "${server_dir}/repository",
    command     => "${server_dir}/bin/server.sh -setup -reinitialize -force -setup-defaults ${server_dir}/conf/deployit.conf",
    user        => $os_user,
    environment => ["JAVA_HOME=${java_home}"]
  }

  file { '/etc/deployit':
    ensure => link,
    target => "${server_dir}/conf";
  }
}

