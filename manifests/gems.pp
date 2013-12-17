# class deployit::gems
class deployit::gems (
  $gem_hash      = $deployit::gem_hash,
  $gem_array     = $deployit::gem_array,
  $gem_use_local = $deployit::gem_use_local) {
  if $::pe_version != undef {
    $gem_provider = 'pe_gem'
  } else {
    $gem_provider = 'gem'
  }

  if str2bool($gem_use_local) {
    Deployit::Resources::Local_gem {
      provider => $gem_provider }

    create_resources(deployit::resources::local_gem, $gem_hash)

  } else {
    Package {
      provider => $gem_provider }

    package { [$gem_array]: ensure => present }
  }
}
