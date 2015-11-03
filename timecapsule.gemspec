$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'timecapsule/version'

Gem::Specification.new do |s|
  s.name        = 'timecapsule'
  s.version     = Timecapsule::VERSION
  s.authors     = ['Renée Hendricksen', 'Kerri Miller', 'Risa Batta']
  s.description = "Great for creating seed data from data entered through your app's UI or the console"
  s.email       = 'robots@nird.us'
  s.homepage    = 'https://github.com/nirds/timecapsule'
  s.license     = 'MIT'
  s.summary     = 'gem for importing and exporting ActiveRecord data.'

  s.add_runtime_dependency 'activerecord',  '>= 2.3.5'
  s.add_runtime_dependency 'activesupport', '>= 2.3.5'
  s.add_runtime_dependency 'rails',         '>= 2.3.5'

  s.files         = `git ls-files -- {bin,lib,test}/* CHANGES.rdoc LICENSE Rakefile README.md`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
