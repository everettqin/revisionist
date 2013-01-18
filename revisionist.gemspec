$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "revisionist/constants"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "revisionist"
  s.version     = Revisionist::VERSION
  s.authors     = ["Aaron Spiegel"]
  s.email       = ["spiegela@gmail.com"]
  s.homepage    = "http://github.com/spiegela/revisionist"
  s.description = "Track model changes with associations"
  s.summary     = s.description

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.9"
  s.add_dependency "activerecord", "~> 3.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-spork"
  s.add_development_dependency "awesome_print"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-debugger"
  s.add_development_dependency "rake-notes"
  s.add_development_dependency "rb-fsevent", "~> 0.9.1"

end
