module Puppet::Parser::Functions
  newfunction(:file_join, :type => :rvalue, :doc => <<-EOS
    Returns the File.join of a path.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "file_join(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    return arguments.join(File::SEPARATOR)
  end
end

# vim: set ts=2 sw=2 et :
