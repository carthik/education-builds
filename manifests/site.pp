$pe_version = '3.0.1'
node default {
  include bootstrap
  include pebase

  include localrepo
  include training

  include vagrant
}

node /learn/ {
  class { 'bootstrap': print_console_login => true, }
  include pebase

  include learning
  stage { 'pe_install': require => Stage['main'], }
  class { 'learning::install': stage => pe_install, }
}
