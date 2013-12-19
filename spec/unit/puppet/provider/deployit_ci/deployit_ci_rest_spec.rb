require 'rubygems'
require 'spec_helper'
require 'pry'

Rspec.configure { |config| config.mock_with :mocha }

describe 'the rest provider for the deployit_ci type' do

  let(:deployit_properties) {{'host' => 'testhost',
			      'startCommand' => '/sbin/service httpd start',
                              'startWaitTime' => '10',
                              'stopCommand' => '/sbin/service httpd stop',
                              'stopWaitTime' => '10',
                              'restartCommand' => '/sbin/service httpd reload',
                              'restartWaitTime' => '3',
                              'defaultDocumentRoot' => '/var/www/html',
                              'configurationFragmentDirectory' => '/tmp/conf_dir',
                              'tags' => { 'test1' => 'test1', 'test2' => 'test2' }}}

  let(:deployit_id) { 'Infrastructure/tst' } 
  let(:deployit_rest_url) { 'http://test.deployit.nl/deployit'} 
  let(:deployit_type) { 'www.ApacheHttpdServer' } 
  let(:deployit_inspection_id) {'insp1'} 
  let(:deployit_task_id) {'task1'} 

  # create type
  let(:resource) { Puppet::Type::Deployit_ci.new({
				:id         => deployit_id,
				:rest_url   => deployit_rest_url,
				:type       => deployit_type,
				:properties => deployit_properties,
				:ensure     => 'present',
				:discovery  => 'false',
			}) }

  # create provider instance
  let(:provider) { resource.provider }

  # construct a valid xml_response 
  let (:xml_response) { provider.to_xml(deployit_id, deployit_type,deployit_properties) } 
  let (:hash_response) { provider.to_hash(:xml_response)}
 
  # do this before each test
  before :each do
    provider.class.stubs(:to_xml).with(deployit_id, deployit_type,deployit_properties).returns(xml_response) 
  end

  describe 'create' do
   it 'does a rest call to the deployit service' do
    RestClient.expects(:post).with("#{deployit_rest_url}/repository/ci/#{deployit_id}", xml_response, {:content_type => :xml}).returns(true)
    provider.create.should be_true
   end
  # it 'should invoke stuff when discovery is set to true' do
  #  provider.resource[:discovery] = true
  #  provider.resource[:discovery_max_wait] = '10'
  #  RestClient.expects(:post).with("#{deployit_rest_url}/inspection/prepare/", xml_response, {:content_type => :xml}).returns(deployit_inspection_id)
  #  RestClient.expects(:post).with("#{deployit_rest_url}/inspection/",deployit_inspection_id, {:content_type => :xml}).returns(deployit_task_id)
  #  RestClient.expects(:post).with("#{deployit_rest_url}/task/#{deployit_task_id}/start", '', {:content_type => :xml}).returns('inspection')
  #  RestClient.expects(:get).with("#{deployit_rest_url}/task/#{deployit_task_id}", {:accept => :xml, :content_type => :xml }).returns('
  #  XmlSimple.expects(:xml_in).with(:xml
  #  provider.create.should be_true 
  # end
  end 

  describe 'destroy' do
    it 'should do a rest_delete call to the deployit rest url' do
	RestClient.expects(:delete).with("#{deployit_rest_url}/repository/ci/#{deployit_id}", {:accept => :xml, :content_type => :xml }).returns(:true)
	provider.destroy.should be_true
    end
  end

  
  
  
end


