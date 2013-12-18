Puppet::Type.type(:deployit_ci).provide(:rest) do

  confine :feature => :restclient

  has_feature :restclient

  def create
    ci_xml = to_xml(resource[:id],resource[:type],resource[:properties])

    if resource[:discovery]
      inspection = rest_post "inspection/prepare/", ci_xml
      task_id = rest_post "inspection/", inspection
      rest_post "task/#{task_id}/start"

      max_wait = resource[:discovery_max_wait].to_i
      while max_wait > 0
        state = to_hash(rest_get "task/#{task_id}")['@state']

        case state
        when 'EXECUTED'
          break
        when 'STOPPED', 'DONE', 'CANCELLED'
          fail "Discovery of #{resource[:id]} failed, invalid inspection task #{task_id} state #{state}"
        when 'EXECUTING', 'PENDING', 'QUEUED'
          debug "Waiting for discovery to finish, task: #{task_id}, current state: #{state}, wait time left: #{max_wait}"
        end
        max_wait = max_wait - 1
        sleep 1
      end
      if max_wait == 0
        fail "Discovery of #{resource[:id]} failed, max wait time #{resource[:discovery_max_wait]} exceeded"
      end

      rest_post "task/#{task_id}/archive"
      inspection_result = rest_post "inspection/retrieve/#{task_id}"
      rest_post "repository/cis", inspection_result
    else
      rest_post "repository/ci/#{resource[:id]}", ci_xml
    end
  end

  def destroy
    rest_delete "repository/ci/#{resource[:id]}"
  end

  def exists?
    xml = rest_get "repository/exists/#{resource[:id]}"
    return to_hash(xml) == "true"
  end

  def properties
    ci_xml = rest_get "repository/ci/#{resource[:id]}"
    ci_hash = to_hash(ci_xml)

    # Add unmanaged k/v pairs that deployit returns to our properties.
    # Otherwise these will be reset when updating any other property.
    ci_hash.each do |k, v|
      resource[:properties][k] = v unless resource[:properties].include? k

      # Temporarily replace password properties as well, until we can
      # encode passwords ourselves
      resource[:properties][k] = v if (k == 'password' or k == 'passphrase') and v.start_with?('{b64}')
    end
    ci_hash
  end

  def properties=(value)
    ci_xml = to_xml(resource[:id],resource[:type],resource[:properties])
    rest_put "repository/ci/#{resource[:id]}", ci_xml
  end

  #private

  def rest_get(service)
    RestClient.get "#{resource[:rest_url]}/#{service}", {:accept => :xml, :content_type => :xml }
  end

  def rest_post(service, body='')
    RestClient.post "#{resource[:rest_url]}/#{service}", body, {:content_type => :xml }
  end

  def rest_put(service, body)
    RestClient.put "#{resource[:rest_url]}/#{service}", body, {:content_type => :xml }
  end

  def rest_delete(service)
    RestClient.delete "#{resource[:rest_url]}/#{service}", {:accept => :xml, :content_type => :xml }
  end

  def to_xml(id, type, properties)
    props = {'@id' => id}.merge(properties)
    XmlSimple.xml_out(
      props,
      {
        'RootName'   => type,
        'AttrPrefix' => true,
        'GroupTags'  => {
          'tags'         => 'value',
          'servers'      => 'ci',
          'members'      => 'ci',
          'dictionaries' => 'ci',
          'entries'      => 'entry'
        },
      }
    )
  end

  def to_hash(xml)
    XmlSimple.xml_in(
      xml,
      {
        'ForceArray' => false,
        'AttrPrefix' => true,
        'GroupTags'  => {
          'tags'         => 'value',
          'servers'      => 'ci',
          'members'      => 'ci',
          'dictionaries' => 'ci',
          'entries'      => 'entry'
        },
      }
    )
  end
end
