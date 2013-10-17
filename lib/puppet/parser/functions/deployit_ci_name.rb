require 'pathname'

module Puppet::Parser::Functions
  newfunction(:deployit_ci_name, :type => :rvalue) do |args|
    Pathname.new(args[0]).basename.to_s
  end
end

