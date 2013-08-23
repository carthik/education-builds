#!/usr/bin/env ruby

require 'rubygems'
require 'serverspec'
require 'pathname'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.tty = true
  c.color_enabled = true
  c.add_formatter(:json)
  if ENV['ASK_SUDO_PASSWORD']
    require 'highline/import'
    c.sudo_password = ask("Enter sudo password: ") { |q| q.echo = false }
  else
    c.sudo_password = ENV['SUDO_PASSWORD']
  end

  #c.before(:all, &:silence_output)
  #c.after(:all, &:enable_output)
end

# Redirects stderr and stdout to /dev/null.
def silence_output
  @orig_stderr = $stderr
  @orig_stdout = $stdout

  # redirect stderr and stdout to /dev/null
  $stderr = File.new('/dev/null', 'w')
  $stdout = File.new('/dev/null', 'w')
end

# Replace stdout and stderr so anything else is output correctly.
def enable_output
  $stderr = @orig_stderr
  $stdout = @orig_stdout
  @orig_stderr = nil
  @orig_stdout = nil
end

config = RSpec.configuration
json_formatter = RSpec::Core::Formatters::JsonFormatter.new(config.out)
reporter  = RSpec::Core::Reporter.new(json_formatter)
config.instance_variable_set(:@reporter, reporter)

## Run RSpec on the policies directory
RSpec::Core::Runner.run(["/root/.testing/spec/"])

total = 0
failures = 0
json_formatter.output_hash[:examples].each do |example|
  total += 1
  if example[:status] == 'failed' then
    failures += 1
    if ARGV[0] != 'brief'
      puts "-- Incomplete task: #{example[:full_description]}" 
    end
  else
  #  puts "-- Task Completed!: #{example[:full_description]}"
  end
end
successes = total - failures

if ARGV[0] == 'brief'
  STDOUT.puts "#{successes}/#{total}"
else
  puts "You successfully completed #{successes} tasks, out of a total of #{total} tasksq!"
end
