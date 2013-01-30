# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end


guard 'minitest' do
  # with Minitest::Unit
  # watch(%r|^test/(.*)\/?test_(.*)\.rb|)
  # watch(%r|^lib/(.*)([^/]+)\.rb|)     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  # watch(%r|^test/test_helper\.rb|)    { "test" }

  # with Minitest::Spec
  watch(%r|^spec/(.*)_spec\.rb|)
  watch(%r|^lib/.*/(.*)([^/]+)\.rb|)     { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r|^lib/(.*)([^/]+)\.rb|)     { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r|^spec/spec_helper\.rb|)    { "spec" }
end



#guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
#  watch('config/application.rb')
#  watch('config/environment.rb')
#  watch('config/environments/test.rb')
#  watch(%r{^config/initializers/.+\.rb$})
#  watch('Gemfile')
#  watch('Gemfile.lock')
#  watch('spec/spec_helper.rb') { :rspec }
#  watch('test/test_helper.rb') { :test_unit }
#  watch(%r{features/support/}) { :cucumber }
#end
