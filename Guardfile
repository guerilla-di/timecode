# A sample Guardfile
# More info at https://github.com/guard/guard#readme


# parameters:
#  output     => the formatted to use
#  backtrace  => number of lines, nil =  everything
guard 'bacon' do
  watch(%r{^lib/(.+)\.rb$})     { |m| "test/test_#{m[1]}.rb" }
  watch(%r{test/.+\.rb$})
end

