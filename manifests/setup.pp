class gitcrypt::setup {
  include git
  $gitcrypt_dir = $osfamily ? {
    /windows/ => "C:\\ProgramData\\gitcrypt",
    default => '/opt/gitcrypt'
  }
  $parent_dir = dirname($gitcrypt_dir)
  $dir_basename = basename($gitcrypt_dir)
  $bak_path = bak_mv($gitcrypt_dir)
  file {'gitcrypt_parent_dir':
    path => $parent_dir,
    ensure => directory,
  }

  if $osfamily == 'windows' {
    exec {"git_clone_gitcrypt":
      path => [
        "C:/Program Files (x86)/Git/cmd",
        "C:/Chocolatey/bin",
        "C:/Windows",
        "C:/Windows/System32",
        'C:/Windows/System32/WindowsPowerShell/v1.0',
      ],
      cwd => $parent_dir,
      command => "git clone https://github.com/shadowhand/git-encrypt.git $dir_basename",
    }
    #$gitcrypt_path = file_join($gitcrypt_dir, 'gitcrypt')
    $gitcrypt_path = file_join_win($gitcrypt_dir, 'gitcrypt')
    $git_cmd_dir = "C:\\Program Files (x86)\\Git\\cmd"
    $git_bash_path = "C:\\Program Files (x86)\\Git\\bin\\bash.exe"
    $gitcrypt_cmd = file_join($git_cmd_dir, 'gitcrypt.cmd')
    $gitcrypt_bash_cmd = file_join($git_cmd_dir, 'gitcrypt_bash.cmd')

    file {"gitcrypt_cmd":
      path => $gitcrypt_cmd,
      content => template('tkh-gitcrypt/gitcrypt.cmd.erb'),
      source_permissions => ignore,
      ensure => present,
    }
    file {"gitcrypt_bash_cmd":
      path => $gitcrypt_bash_cmd,
      content => template('tkh-gitcrypt/gitcrypt_bash.cmd.erb'),
      source_permissions => ignore,
      ensure => present,
    }
    File['gitcrypt_parent_dir']->
    Exec['git_clone_gitcrypt']->File['gitcrypt_cmd']->File['gitcrypt_bash_cmd']
  } else {
    file {'gitcrypt_dir':
      path => $gitcrypt_dir,
      ensure => directory,
    }
    exec {"rm_gitcrypt":
      path => [ "/bin", "/usr/bin", "/usr/local/bin" ],
      cwd => $gitcrypt_dir,
      command => "rm -rf git-encrypt",
    }
    exec {"git_clone_gitcrypt":
      path => [ "/bin", "/usr/bin", "/usr/local/bin" ],
      cwd => $gitcrypt_dir,
      command => "git clone https://github.com/shadowhand/git-encrypt.git",
    }
    file {"crypt_l":
      path => "/usr/local/bin/gitcrypt",
      target => "/opt/gitcrypt/git-encrypt/gitcrypt",
      ensure => 'link',
    }
    file {"merge_l":
      path => "/usr/local/bin/gitcrypt-merge",
      target => "/opt/gitcrypt/git-encrypt/gitcrypt-merge",
      ensure => 'link',
    }
    file {"init_l":
      path => "/usr/local/bin/git-encrypt-init.sh",
      target => "/opt/gitcrypt/git-encrypt/git-encrypt-init.sh",
      ensure => 'link',
    }
    file {"filter_l":
      path => "/usr/local/bin/git-encrypt-filter.sh",
      target => "/opt/gitcrypt/git-encrypt/git-encrypt-filter.sh",
      ensure => 'link',
    }
    File['gitcrypt_dir']->
    Exec['rm_gitcrypt']->
    Exec['git_clone_gitcrypt']->
    File['crypt_l']->
    File['merge_l']->
    File['init_l']->
    File['filter_l']
    #case $operatingsystem {
     #'Ubuntu': {
       #case $lsbdistcodename {
         #'trusty', 'precise': {
           #service {'network-manager':
           #  enable => false,
           #}
         #}
       #}
     #}
    #}
  }
}
