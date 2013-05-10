require 'starter_kit/command'

class StarterKit::Cmd::Puppet < StarterKit::Command
  parameter 'NAME', 'The name of the module to create'

  option ['-s', '--simple'], :flag, 'Deploy a simple module (README, Modulefile, init.pp)', :default => false

  def default_template_dir
    return (simple? ? "#{super}/simple" : "#{super}/standard")
  end

  option ['-u', '--username'], 'USER', 'The puppet forge user name to associate this module with',
    :default => %x{whoami}.chomp

  option ['-l', '--license'], 'LICENSE', 'String describing the license this module uses',
    :default => 'Apache 2'

  option ['-d', '--dependency'], 'DEP ...', 'A dependency in the format of NAME:VERSION:REPO',
    :attribute_name => :dependencies

  alias :project_page :homepage
end

