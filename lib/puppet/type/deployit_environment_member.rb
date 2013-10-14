require 'pathname'

Puppet::Type.newtype(:deployit_environment_member) do
  @doc = 'Manage Deployit Environment members'

  feature :restclient, 'Use REST to update deployit repository'

  ensurable do
    defaultvalues
    defaultto :present
  end

  autorequire (:class) do
    'deployit'
  end

  autorequire (:deployit_ci) do
    self[:members] + [self[:env]]
  end

  newparam(:id, :namevar => true) do
    desc 'Id, must be unique, not used in deployit'
  end

  newparam(:env) do
    desc 'Id of Environment to add members to'
  end

  newproperty(:members, :array_matching => :all) do
    desc 'Array of member CIs'

    # We need to overwrite insync? to verify only the properties that we
    # manage, because Deployit also returns all properties of a CI, which
    # could include properties that are not set by puppet
    def insync?(is)
      ((@should - is).length == 0)
    end
  end

  newparam(:rest_url, :required_features => ['restclient']) do
    desc 'The rest url for making changes to deployit'
  end
end
