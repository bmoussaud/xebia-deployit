require 'pathname'

Puppet::Type.newtype(:deployit_ci) do
  @doc = 'Manage a Deployit Configuration Item'

  feature :restclient, 'Use REST to update deployit repository'

  ensurable do
    defaultvalues
    defaultto :present
  end

  autorequire (:deployit_ci) do
    Pathname.new(self[:id]).dirname
  end

  newparam(:id, :namevar => true) do
    desc 'The ID/path of the CI'

    validate do |value|
      fail("Invalid id: #{value}") unless value =~ /^(Applications|Environments|Infrastructure|Configuration)\/.+$/
    end
  end

  newparam(:type) do
    desc 'Type of the CI'
  end

  newproperty(:properties) do
    desc 'Properties of the CI'

    defaultto({})

    validate do |value|
      fail("Invalid properties: #{value}, expected a hash") unless value.is_a? Hash
    end

    # We need to overwrite insync? to verify only the properties that we 
    # manage, because Deployit also returns all properties of a CI, which
    # could include properties that are not set by puppet
    def insync?(is)
      should = @should.first
      return false unless is.class == should.class

      should.each do |k,v|
        return false unless is[k] == should[k]
      end

      true
    end

    def should_to_s(newvalue)
      newvalue.inspect
    end

    def is_to_s(currentvalue)
      currentvalue.inspect
    end
  end

  newparam(:rest_url, :required_features => ['restclient']) do
    desc 'The rest url for making changes to deployit'
  end
end
