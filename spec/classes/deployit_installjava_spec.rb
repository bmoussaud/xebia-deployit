require 'spec_helper'

describe 'deployit' do 
    let(:facts) {{ :osfamily => 'RedHat' }}
	context 'deployit class server with install_java set to true' do
    	let(:params) {{ :server => 'true',
    				:install_java => 'true'}}
    				
      	it { should create_package('java-1.6.0-openjdk').with_ensure('present')}
  	end
	context 'deployit class server with install_java set to false' do
    	let(:params) {{ :server => 'true',
    				:install_java => 'false'}}
    				
      	it { should_not create_package('java-1.6.0-openjdk').with_ensure('present')}
      	
  	end
  	context 'deployit class server with install_java set to bogus' do
    	let(:params) {{ :server => 'true',
    				:install_java => 'bogus'}}
    				
      	 it do 
      	 	expect {subject}.to raise_error( /boolean/)
      	 end 
  	end
end

