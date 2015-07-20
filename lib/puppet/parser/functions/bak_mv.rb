def add_ext_pref(f, pref)
  return File.basename(f, File.extname(f)) + '.' + pref + File.extname(f) 
end

def add_dext_pref(f, pref1, pref2)
  return add_ext_pref(f, pref1 + '.' + pref2)
end

def bak_mv(src)
  if !File.exists?(src)
      return src
  end
  dir = File.dirname(File.realpath(src))
  base = File.basename(File.realpath(src))
  time = Time.now.strftime("%Y%m%d%H%M%S")
  base_new = add_dext_pref(base, 'bak', time)
  dst = File.join(dir, base_new)
  FileUtils.mv src, dst
  return dst
end

module Puppet::Parser::Functions
  newfunction(:bak_mv, :type => :rvalue) do |arguments|
    return bak_mv(arguments[0])
  end
end
