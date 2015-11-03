# encoding: utf-8

require 'bundler'
require 'rake'
require 'rspec/core/rake_task'
require 'rdoc/task'
require 'rubygems'
require 'thread'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

RSpec::Core::RakeTask.new(:spec)

task default: :spec

Bundler::GemHelper.install_tasks

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "timecapsule #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
