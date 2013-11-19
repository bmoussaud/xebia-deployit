require 'spec_helper'

describe 'deployit' do

	context 'deployit class server adds homedir through base_dir' do
    	let(:facts) {{ :osfamily => 'RedHat' }}
    	let(:params) {{ :server     => 'true',
    					:base_dir  => '/opt/deployit',
                                :version    => '3.9.4'}}

    
      
      	it { should create_file('/opt/deployit/deployit-server').with_owner('deployit').with_ensure('link').with_target('/opt/deployit/deployit-3.9.4-server')}
	it { should create_file('/opt/deployit/deployit-cli').with_owner('deployit').with_ensure('link').with_target('/opt/deployit/deployit-3.9.4-cli')}      
  	end

  	context 'deployit class server adds homedir through server_home_dir and cli_home_dir' do
    	let(:facts) {{ :osfamily => 'RedHat' }}
    	let(:params) {{ :server 		 	=> 'true',
    					:server_home_dir 	=> '/projectx/deployit-server',
    					:cli_home_dir		=> '/projectx/deployit-cli' 	}}

    
      	it { should create_file('/projectx/deployit-server').with_owner('deployit').with_ensure('link')}
	it { should create_file('/projectx/deployit-cli').with_owner('deployit').with_ensure('link') }      
  	end

   	context 'deployit class server_home_dir with illegal path name' do
     	let(:facts) {{ :osfamily => 'RedHat' }}
    	let(:params) {{ :server => 'true',
    					:server_home_dir => 'deployit'}}

        it { expect { should }.to raise_error(Puppet::Error, /path/) }
        
   	end
end
