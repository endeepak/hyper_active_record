# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hyper_active_record/version"

Gem::Specification.new do |s|
  s.name        = "hyper_active_record"
  s.version     = HyperActiveRecord::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Deepak N"]
  s.email       = ["endeep123@gmail.com"]
  s.homepage    = "https://github.com/endeepak/hyper_active_record"
  s.summary     = %q{hyper active record}
  s.description = %q{Makes active record awesome}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency("activerecord", "~> 3.0.0")
  s.add_development_dependency("rspec", "~> 2.5.0")
  s.add_development_dependency("sqlite3", "~> 1.3.3")
  s.add_development_dependency('factory_girl', '~> 1.3.3')
end
