require 'starter_kit/command'

Dir["#{File.dirname(__FILE__)}/*.rb"].each { |f| require f }

class StarterKit::Cmd::Main < Clamp::Command
  option ['-a', '--author'], 'AUTHOR', 'The name of the author'
  option ['-e', '--email'],  'EMAIL',  'The email address of the author'

  subcommand 'puppet', 'Create a puppet module', StarterKit::Cmd::Puppet 
end

