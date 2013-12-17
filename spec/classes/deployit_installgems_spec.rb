require 'spec_helper'

describe 'deployit' do 
  context 'deployit on os puppet' do
    let(:facts) {{ :osfamily => 'RedHat'}}
    # positive tests
	context 'deployit class server with install_gems set to true' do
    	let(:params) {{ :server => 'true',
    					:install_gems => 'true'}}
    				
      	it { should create_package('xml-simple').with_ensure('present').with_provider('gem')}
      	it { should create_package('rest-client').with_ensure('present').with_provider('gem')}
      	
  	end
  	context 'deployit class server with install_gems set to true and gem_hash specified' do
    	let(:params) {{ :server 		=> 'true',
    				    :install_gems	=> 'true',
    				    :gem_hash 		=> {'xml-simple' => { 'source' => 'puppet:///modules/deployit/gems/xml-simple-1.1.2.gem','version' => '1.1.2'},
    				    			  		'rest-client' => { 'source' => 'puppet:///modules/deployit/gems/rest-client-1.6.7.gem', 'version' => '1.6.7'}}
    				 }}
    	it { should create_deployit__resources__local_gem('xml-simple').with_provider('gem').with_source('puppet:///modules/deployit/gems/xml-simple-1.1.2.gem').with_version('1.1.2')} 			
      	it { should create_deployit__resources__local_gem('rest-client').with_provider('gem').with_source('puppet:///modules/deployit/gems/rest-client-1.6.7.gem').with_version('1.6.7')} 
      	it { should create_package('xml-simple').with_ensure('present').with_provider('gem').with_source('/var/tmp/xml-simple-1.1.2.gem')}
      	it { should create_package('rest-client').with_ensure('present').with_provider('gem').with_source('/var/tmp/rest-client-1.6.7.gem')}
      	
  	end
  	context 'deployit class server with install_gems set to true and gem_hash specified and gem_use_local set to false' do
    	let(:params) {{ :server 		=> 'true',
    				    :install_gems	=> 'true',
    				    :gem_hash 		=> {'xml-simple' => { 'source' => 'puppet:///modules/deployit/gems/xml-simple-1.1.2.gem','version' => '1.1.2'},
    				    			  		'rest-client' => { 'source' => 'puppet:///modules/deployit/gems/rest-client-1.6.7.gem', 'version' => '1.6.7'}
    				    			  		},
    				    :gem_use_local  => 'false'
    				 }}
    	it { should_not create_deployit__resources__local_gem('xml-simple')} 			
      	it { should_not create_deployit__resources__local_gem('rest-client')} 
      	it { should create_package('xml-simple')}
      	it { should create_package('rest-client')}
      	
  	end
  	# negative tests
	context 'deployit class server with install_gems set to false' do
    	let(:params) {{ :server => 'true',
    					:install_gems => 'false'}}
    				
      	it { should_not create_package('xml-simple').with_ensure('present').with_provider('gem')}
      	
  	end
  	
  	context 'deployit class server with install_gems set to bogus' do
    	let(:params) {{ :server => 'true',
    					:install_gems => 'bogus'}}
    				
      	 it do 
      	 	expect {subject}.to raise_error( /boolean/)
      	 end 
  	end
	context 'deployit class server with gem_hash set to bogus' do
    	let(:params) {{ :server => 'true',
    					:gem_hash => 'bogus'}}
    				
      	 it do 
      	 	expect {subject}.to raise_error( /Hash/)
      	 end 
  	end
  	
end
context 'deployit on pe puppet' do  
    let(:facts) {{ :osfamily => 'RedHat',
    			   :pe_version => '2.7' }}
    # positive tests
	context 'deployit class server with install_gems set to true' do
    	let(:params) {{ :server => 'true',
    					:install_gems => 'true'}}
    				
      	it { should create_package('xml-simple').with_ensure('present').with_provider('pe_gem')}
      	it { should create_package('rest-client').with_ensure('present').with_provider('pe_gem')}
      	
  		end  	
	end
end
