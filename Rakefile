require 'rubygems'
require 'hoe'
require './lib/timecode.rb'

Hoe.spec('timecode') do |p|
  p.version = Timecode::VERSION
  p.readme_file   = 'README.rdoc'
  p.extra_rdoc_files  = FileList['*.rdoc']
  
  p.developer('Julik', 'me@julik.nl')
  p.extra_dev_deps = {"bacon" => ">=0"}
  p.rubyforge_name = 'guerilla-di'
  p.remote_rdoc_dir = 'timecode'
end