require 'spec_helper_system'

describe "deployit class:" do

  context 'should run successfully' do
    pp = "class { 'deployit': }"
    context puppet_apply(pp) do
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      # Not until deprecated variables fixed.
      #its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end
  end

  describe service('deployit') do
    it { should be_running }
  end

  context shell 'cat /etc/passwd' do
      its(:stdout) { should =~ /deployit/ }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
  end
  context shell 'cat /etc/group' do
      its(:stdout) { should =~ /deployit/ }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
  end
  context shell 'service deployit stop' do
      its(:stdout) { should =~ /stopped/ }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero}
  end
   context shell 'service deployit start' do
      its(:stdout) { should =~ /started/ }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero}
  end
end
