require 'pathname'

module Puppet::Parser::Functions
  newfunction(:deployit_ci_parent_id, :type => :rvalue) do |args|
    Pathname.new(args[0]).dirname.to_s
  end
end

