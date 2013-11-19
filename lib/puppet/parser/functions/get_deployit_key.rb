require 'yaml'
require 'fileutils'

 module Puppet::Parser::Functions
  newfunction(:get_deployit_key, :type => :rvalue, :doc => <<-EOS
    returns a public or private keys string depending on a label argument
    usage: get_deployit_key(<public/private>, <label argument>, [<keyType>] )
    EOS
    ) do |arguments|
    
    # check the input . we can handle 2 or three arguments
    raise(Puppet::ParseError, "get_deployit_keys(): Wrong number of arguments " +
      "given (#{arguments.length} for 2)") if arguments.length < 2 
    raise(Puppet::ParseError, "get_deployit_keys(): Wrong number of arguments " +
      "given (#{arguments.length} for 3)") if arguments.length > 3  
    raise(Puppet::ParseError, "get_deployit_keys(): Wrong argument" +
      "given (#{arguments[3]}) should be one of rsa/dsa") if arguments.length == 3 and not ["rsa", "dsa"].include?(arguments[2]) 
    raise(Puppet::ParseError, "get_deployit_keys(): Wrong argument" +
      "given (#{arguments[1]}) should be one of public/private") if not ["public", "private"].include?(arguments[0]) 
   
   	#assign the arguments to more sensible names
   	keypart=arguments[0]
   	keylabel=arguments[1]
   	keytype=arguments[2] || "rsa"
   	keydirname = File.join(Puppet[:vardir],"keysdir")
   	yamlIndexName=File.join(keydirname, "index.yaml")
   	privatekeyfilename = File.join(keydirname, "#{keylabel}.#{keytype}") 
	publickeyfilename = File.join(keydirname, "#{keylabel}.#{keytype}.pub")
   	
    # create keys dir under puppet files if none exists
    unless File.directory?(keydirname)
  		FileUtils.mkdir_p(keydirname)
	end
	
	# create yaml index linking arguments to keys
	
	cache = YAML.load_file(yamlIndexName) if File.exists?(yamlIndexName)
    cache = {} if cache == nil

		
	unless cache.has_key?(keylabel) 
	
	    # create public and private keys if they do not exist
		privatekeyfilename = File.join(keydirname, "#{keylabel}.#{keytype}") 
		publickeyfilename = File.join(keydirname, "#{keylabel}.#{keytype}.pub")
    	# compose the ssh-keygen command
    
    	cmd="/usr/bin/ssh-keygen -f #{privatekeyfilename} -t #{keytype} -N '' 1>/dev/null 1>&2"
    	
    	# create the keys
    	output = `#{cmd}`
 
    	# secure the files 
    	File.chmod(0600, publickeyfilename) if File.exists?(publickeyfilename)
    	File.chmod(0600, privatekeyfilename) if File.exists?(privatekeyfilename)
    	
        # register the key files in the yaml
        cache[keylabel] = {} 
    	cache[keylabel]['public'] = publickeyfilename
    	cache[keylabel]['private'] = privatekeyfilename 
    else 
    	privatekeyfilename = cache[keylabel]['private']
		publickeyfilename = cache[keylabel]['public']
    end 
 
	# return the public or private keys depending on the arguments
	file = File.open(publickeyfilename) if keypart == 'public'
	file = File.open(privatekeyfilename) if keypart == 'private'
	output = file.read
	
	# dump the keys cache back to the indexfile
 	File.open(yamlIndexName, "w") do |f|
      YAML::dump(cache, f)
    end
    
	#change the mode of the indexfile to something only we can read
    File.chmod(0600, yamlIndexName) if File.exists?(yamlIndexName)
    
    return output
    
 
  end
end