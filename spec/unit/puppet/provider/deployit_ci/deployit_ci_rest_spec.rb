require 'puppet'
require 'fileutils'
require 'puppet/type/deployit_ci'

Rspec.configure { |config| config.mock_with :mocha }

describe 'the rest provider for the deployit_ci type' do

  # create type
  let(:resource) { Puppet::Type::Deployit_ci.new({:id => 'Environments/tst' }) }

  # create provider instance
  subject {Puppet::Type.type(:deployit_ci).provide(:rest).new(resource) }

  
end


