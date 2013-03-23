require 'rubygems'
require 'jeweler'
require './lib/timecode'

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

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

Jeweler::RubygemsDotOrgTasks.new

task :default => [ :test ]