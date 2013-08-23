class learning {
  File {
    owner => root,
    group => root,
    mode  => 644,
  }

  file { '/root/learning.answers':
    ensure => file,
    source => 'puppet:///modules/learning/learning.answers',
  }

  # Print this info when we log in, too.
  file {'/etc/motd':
    ensure => file,
    owner  => root,
    mode   => 0644,
    content => "Welcome to the Learning Puppet VM! 

To view your current IP address, run `facter ipaddress_eth0`

To log in to the Puppet Enterprise console, go to:
https://<YOUR IP ADDRESS HERE>

  User: puppet@example.com
  Password: learningpuppet
",
  }

  exec { 'install serverspec':
    command => '/opt/puppet/bin/gem install serverspec',
    creates => '/opt/puppet/bin/serverspec-init',
  }
}
