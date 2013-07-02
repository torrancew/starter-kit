require 'starter_kit/command'

Dir["#{File.dirname(__FILE__)}/*.rb"].each { |f| require f }

class StarterKit::Cmd::Main < Clamp::Command
  subcommand 'puppet', 'Create a puppet module', StarterKit::Cmd::Puppet 
  subcommand 'ruby',   'Create a ruby project',  StarterKit::Cmd::Ruby
end

