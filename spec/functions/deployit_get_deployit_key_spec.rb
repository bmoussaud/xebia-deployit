require 'spec_helper'

describe 'get_deployit_key' do
        it { should run.with_params('hibbyjibby').and_raise_error(Puppet::ParseError) }
        it { should run.with_params('public', 'labelx' , 'sadfsadf').and_raise_error(Puppet::ParseError)}
	it { should run.with_params('public', 'labelx' , 'rsa', 'fasdfasdf').and_raise_error(Puppet::ParseError)}
        it { should run.with_params('public', 'labelx')}
	it { should run.with_params('public', 'labelx', 'rsa')}
end