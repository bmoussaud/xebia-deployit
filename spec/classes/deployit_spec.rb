require 'spec_helper'

describe 'deployit' do


  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      describe "deployit class without any parameters on #{osfamily}" do

        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should include_class('deployit::params') }
        it { should include_class('deployit::validation') }
      end
    end
  end

  context 'deployit class server stream (server parameter set to true)' do
    let(:facts) {{ :osfamily => 'RedHat' }}
    let(:params) {{ :server => 'true' }}

    ['puppetfiles', 'packages'].each do |installtype|
      describe "with parameter installtype set to #{installtype}" do

        let(:params) {{ :install_type => installtype }}

        it { should include_class('deployit::install') }
      end
    end

    describe "with parameter installtype set to bogus" do
      let(:params) {{ :install_type => 'bogus' }}

      it { expect { should }.to raise_error(Puppet::Error, /unsupported install_type/) }
    end
  end

  context 'deployit class client stream (client parameter set to true' do
    let(:facts) {{ :osfamily => 'RedHat' }}


    describe "basic test" do
      let(:params) {{ :server => 'false' }}
      it { should include_class('deployit::client::user')}
      it { should include_class('deployit::client::config')}
      it { should_not include_class(['deployit::install','deployit::config','deployit::service'])}
    end

    describe "with parameter os_user set to deployit" do
      let(:param){{ :os_user => 'deployit',
                    :server  => 'false' }}

      it {should create_user('deployit') }

    end

    describe "with parameter os_group set to deployit" do
      let(:param){{ :os_group => 'deployit',
                    :server => 'false' }}

      it {should create_group('deployit') }

    end

    describe "with parameter client_sudo set to true" do
      let(:params) {{ :client_sudo => 'true',
                      :os_user => 'deployit',
                      :server => 'false' }}

      it { should include_class('deployit::client::user') }
      it { should create_file('/etc/sudoers.d/50_deployit').with_content(/deployit*/) }

    end
    describe "with parameter client_sudo set to false" do
      let(:params) {{ :client_sudo => 'false',
                      :server => 'false' }}

      it { should_not include_class('sudo')}

    end
    describe "with parameter client_cis filled" do
      let(:params) {{ :server     => 'false',
                      :rest_url   => 'http://admin:admin@0.0.0.0:4516/',
                      :client_cis => { '/Infrastructure/TestHost' => { 'ensure' => 'present',
                                                                        'discovery' => 'false',
                                                                        'properties' => {'password' => 'test'},
                                                                        'type' => 'overthere.SshHost'}}
                   }}

      it { should create_deployit_ci('/Infrastructure/TestHost').\
        with_rest_url('http://admin:admin@0.0.0.0:4516/').\
        with_ensure('present').\
        with_discovery('false').\
        with_type('overthere.SshHost') }
    end

    describe "with parameter client_cis not a hash" do
      let(:params) {{ :server     => 'false',
                      :rest_url   => 'http://admin:admin@0.0.0.0:4516/',
                      :client_cis => 'bogus'
                   }}

      it { expect {should}.to raise_error(Puppet::Error, /"bogus" is not a Hash/) }
    end
    describe "with parameter use_exported_resources switched on" do
      let(:params) {{ :server => 'false',
                      :client_cis => { '/Infrastructure/TestHost' => { 'ensure' => 'present',
                                                                       'discovery' => 'false',
                                                                       'properties' => {'password' => 'test'},
                                                                       'type' => 'overthere.SshHost'}},
                      :use_exported_resources => 'true'
                   }}
      it { should_not create_deployit_ci('/Infrastructure/TestHost') }
    end
  end

end
