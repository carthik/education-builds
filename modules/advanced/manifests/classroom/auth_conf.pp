class advanced::classroom::auth_conf {

  include auth_conf::defaults
  include request_manager
  auth_conf::acl { '^/facts/([^/]+)$':
    regex      => true,
    acl_method => 'save',
    allow      => '$1',
    auth       => 'yes',
  }

}
