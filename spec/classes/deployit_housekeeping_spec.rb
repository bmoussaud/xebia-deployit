require 'spec_helper'

describe 'deployit' do 

	context 'deployit class server installs housekeeping' do
    let(:facts) {{ :osfamily => 'RedHat' }}
    let(:params) {{ :server => 'true',
    				:enable_housekeeping => 'true',
    				:base_dir => '/opt/deployit'}}

    
      it { should include_class('deployit::housekeeping') }
      it { should create_cron('deployit-housekeeping').with_user('root').with_hour('2').with_minute('5') }
      it { should create_file('/opt/deployit/deployit-server/scripts/deployit-housekeeping.sh').with_ensure('present')}
      it { should create_file('/opt/deployit/deployit-server/scripts/garbage-collector.py').with_ensure('absent')}
      it { should create_file('/opt/deployit/deployit-server/scripts/housekeeping.py').with_ensure('present')}
      
  end
end

