define apt::key($ensure=present, $source="", $content="") {

  case $ensure {

    present: {
      if $content == "" {
        if $source == "" {
          $thekey = "/usr/bin/gpg --keyserver pgp.mit.edu --recv-key '${name}' && gpg --export --armor '${name}'"
        }
        else {
          $thekey = "/usr/bin/wget -O - '${source}'"
        }
      }
      else {
        $thekey = "/bin/echo '${content}'"
      }


      exec { "import gpg key ${name}":
        command => "${thekey} | /usr/bin/apt-key add -",
        unless => "/usr/bin/apt-key list | grep -Fqe '${name}'",
        before => Exec["apt-get_update"],
        notify => Exec["apt-get_update"],
      }
    }
    
    absent: {
      exec {"/usr/bin/apt-key del ${name}":
        onlyif => "apt-key list | grep -Fqe '${name}'",
      }
    }

  }
}
