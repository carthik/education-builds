require 'spec_helper'

describe group('webdev') do
  it { should exist }
end

describe user('webtest') do
  it { should exist }
  it { should belong_to_group 'webdev' }
end

describe group('apache') do
  it { should exist }
end

describe file('/var/www') do
  it { should be_directory }
  it { should be_owned_by  'apache'}
  it { should be_grouped_into 'webdev' }
end

describe file('/var/www/html') do
  it { should be_directory }
  it { should be_owned_by  'apache'}
  it { should be_grouped_into 'webdev' }
end

describe file('/home/webtest') do
  it { should be_directory }
  it { should be_owned_by  'webtest'}
end

describe package('httpd') do
  it { should be_installed }
end

describe package('mysql') do
  it { should be_installed }
end

describe package('php') do
  it { should be_installed }
end

describe package('php-cli') do
  it { should be_installed }
end

describe package('php-mysql') do
  it { should be_installed }
end
