require 'puppet'
require 'puppet/type/deployit_ci'

describe Puppet::Type.type(:deployit_ci) do 
	subject { Puppet::Type.type(:deployit_ci).new(:id => 'Environments/test' ) } 

	it 'should accept ensure' do
	  subject[:ensure] = :present
	  subject[:ensure].should == :present
	end

	it 'should accept type' do
	  subject[:type] = 'overthere_SshHost'
	  subject[:type].should == 'overthere_SshHost'
	end

	it 'should accept a hash for properties' do 
	  subject[:properties] = { 'test1' => 'test1', 'test2' => 'test2' } 
	  subject[:properties] == { 'test1' => 'test1', 'test2' => 'test2' }
	end

	it 'should not accept anything else as input to properties' do 
	  expect { subject[:properties] = 'tst' }.to raise_error(Puppet::Error, /Invalid/)
	end

	it 'should accept true of false on discovery' do
          subject[:discovery] = 'true'   
          subject[:discovery].should == true  
	end

	it 'should not accept anything else then true or false on discovery' do
	  expect { subject[:discovery] = 'deployit'}.to raise_error 
	end

	it 'should accept an integer on discovery_max_wait' do
	  subject[:discovery_max_wait] = '10'
	  subject[:discovery_max_wait] == '10'
	end

	it 'should accept rest_url' do
	  subject[:rest_url] = 'http://deployit/'
	  subject[:rest_url] == 'http://deployit/'
	end
end
