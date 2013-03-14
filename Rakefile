# VMLib Rakefile
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "bundler/gem_tasks"
require "vmlib/version"

# Unit tests task
desc "Run unit test task for vmlib-#{VMLib::VERSION}"
task :test do
  $:.unshift(::File.expand_path('lib', ::File.dirname(__FILE__)))
  if ::ENV['TEST_CASE']
    test_files = ::Dir.glob("test/#{::ENV['TEST_CASE']}.rb")
  else
    test_files = ::Dir.glob("test/**/test_*.rb")
  end
  $VERBOSE = true

  test_files.each do |path|
    load path
    puts "Loaded testcase #{path}"
  end
end

