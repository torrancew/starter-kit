require 'rake'
require 'rdoc/task'
require 'bundler/gem_tasks'

Rake::RDocTask.new :doc do |rdoc|
  rdoc.main     = 'README.rdoc'
  rdoc.rdoc_dir = 'doc'

  rdoc.rdoc_files.include('README.rdoc', 'lib   /*.rb')
end

