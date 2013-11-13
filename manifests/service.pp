# Class deployit::service
#
# This class manages the deployit service
class deployit::service {
  service { 'deployit': 
    ensure => running,
    enable => true,
  }
}