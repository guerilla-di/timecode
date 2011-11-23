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

Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
desc "Run all tests"
task :test do
  ruby "bacon -Ilib --automatic --quiet"
end

task :default => [ :test ]