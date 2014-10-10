guard :minitest, all_on_start: false, all_after_pass: false do
  watch(%r{^lib/metador/(.+)\.rb$})     { |m| "test/#{m[1]}_test.rb" }

  watch(%r{^test/.+_test\.rb$})

  watch('test/test_helper.rb')  { "test" }
end