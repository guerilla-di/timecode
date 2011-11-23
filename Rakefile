require 'rubygems'
require 'jeweler'
require 'bacon'
require './lib/timecode'
require './lib/bacon_task'

Jeweler::Tasks.new do |gem|
  gem.version = Timecode::VERSION
  gem.name = "timecode"
  gem.summary = "Timecode value class"
  gem.email = "me@julik.nl"
  gem.homepage = "http://guerilla-di.org/timecode"
  gem.authors = ["Julik Tarkhanov"]
  gem.license = 'MIT'
  
  # Do not package invisibles
  gem.files.exclude ".*"
end

Jeweler::RubygemsDotOrgTasks.new

desc "Run all tests"
Bacon::Rake::Task.new do |t|
  t.format = :specdoc
  t.files << "test/test_timecode.rb"
end

task :default => [ :test ]