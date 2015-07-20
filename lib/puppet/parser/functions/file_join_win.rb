module Puppet::Parser::Functions
  newfunction(:file_join_win, :type => :rvalue, :doc => <<-EOS
    Returns the File.join of a path.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "file_join_win(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    return arguments.join('\\')
  end
end

# vim: set ts=2 sw=2 et :
