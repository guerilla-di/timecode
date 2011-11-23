require 'rake'
require 'rake/tasklib'
## Like 99% of this is ripped straight from the bacon binary.
module Bacon
  class Rake
    class Task < ::Rake::TaskLib
      attr_accessor :format
      attr_accessor :files
      attr_accessor :name

      def files
        @files ||= []
      end

      def get_format k
        case k.to_sym
          when :specdoc then
            'SpecDoxOutput'
          when :test_unit then
            'TestUnitOutput'
          when :tap then
            'TapOutput'
          when :knock then
            'KnockOutput'
          else
            k
        end
      end

      def format= k
        @format = k
      end

      def initialize(*args)
        @name = args.shift || :test
        @format = :specdoc
        yield self if block_given?
        if files.empty?
          files.concat Dir["test/**/test_*.rb"]
          files.concat Dir["test/**/*_test.rb"]
          files.concat Dir["test/**/spec_*.rb"]
          files.concat Dir["spec/**/spec_*.rb"]
          files.concat Dir["spec/**/*_spec.rb"]
        end
        desc "Run all bacon tests." unless ::Rake.application.last_comment
        task name do
          require 'bacon'
          Bacon.extend Bacon.const_get(get_format(format)) rescue abort "No such format #{format}"
          Bacon.summary_on_exit
          files.each { |f| load f }
        end
      end
    end
  end
end


## Example
## Bacon::Rake::Task.new("test") do |t|
##  t.format :specdoc
##  t.files << test/my_test.rb
## end