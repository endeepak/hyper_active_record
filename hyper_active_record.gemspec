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
end
