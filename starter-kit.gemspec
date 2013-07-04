require 'find'
require File.expand_path(File.join('lib', 'starter_kit', 'version.rb'))

Gem::Specification.new do |spec|
  spec.name    = 'starter-kit'
  spec.version = StarterKit::VERSION
  spec.authors = ['Tray Torrance']
  spec.email   = ['devwork@warrentorrance.com']
  spec.summary = 'A tool for creating software projects from templates'

  spec.files = Find.find('./').select do |f|
    f.gsub(%{^\./}, '') if f.match(%r{/(lib|bin|templates)/})
  end

  spec.bindir = 'bin'
  Dir['bin/*'].each do |b|
    spec.executables << b.gsub('bin/', '')
  end

  spec.add_dependency('clamp')
  spec.add_development_dependency('bundler')
end
