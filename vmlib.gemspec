# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vmlib/version'

Gem::Specification.new do |s|
  s.name                    = 'vmlib'
  s.version                 = VMLib::VERSION
  s.date                    = '2013-03-12'
  s.summary                 = "Version Manager Library"
  s.description             = "A gem to handle software versions"
  s.required_ruby_version   = "~> 1.9.3"
  s.authors                 = ["Nirenjan Krishnan"]
  s.email                   = 'nirenjan@gmail.com'
  #s.files                   = ["lib/vmlib.rb"]
  s.license                 = "MIT"
  s.homepage                = 'http://rubygems.org/gems/vmlib'

  s.files           = `git ls-files`.split($/)
  s.executables     = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files      = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths   = ["lib"]

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
end
