Puppet::Type.type(:deployit_ci).provide(:rest) do

  confine :feature => :restclient

  has_feature :restclient

  def create
    xml = to_xml(resource[:id],resource[:type],resource[:properties])
    RestClient.post "#{resource[:rest_url]}/ci/#{resource[:id]}", xml, {:content_type => :xml}
  end

  def destroy
    RestClient.delete "#{resource[:rest_url]}/ci/#{resource[:id]}"
  end

  def exists?
    xml = RestClient.get "#{resource[:rest_url]}/exists/#{resource[:id]}", {:accept => :xml, :content_type => :xml }
    return to_hash(xml) == "true"
  end

  def properties
    xml = RestClient.get "#{resource[:rest_url]}/ci/#{resource[:id]}", {:accept => :xml, :content_type => :xml }
    hash = to_hash(xml)

    # Add unmanaged k/v pairs that deployit returns to our properties.
    # Otherwise these will be reset when updating any other property.
    hash.each do |k, v|
      resource[:properties][k] = v unless resource[:properties].include? k
    end
    hash
  end

  def properties=(value)
    xml = to_xml(resource[:id],resource[:type],resource[:properties])
    RestClient.put "#{resource[:rest_url]}/ci/#{resource[:id]}", xml, {:content_type => :xml}
  end

  private

  def to_xml(id, type, properties)
    props = {"@id" => id}.merge(properties)
    xml = XmlSimple.xml_out(props, {"RootName" => type, "AttrPrefix" => true})
    info "xml: #{xml}"
    xml
  end

  def to_hash(xml)
    hash = XmlSimple.xml_in(xml, {"AttrPrefix" => true})
    info "hash: #{hash.inspect}"
    hash
  end
end
