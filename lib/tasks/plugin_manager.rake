# Load plugins' rake tasks
require_relative '../plugin_manager'

Rake::Task['redmine:plugins:test'].clear

namespace :redmine do
  namespace :plugins do

    desc 'Running tests on plugins defined in plugin_manager config file or in NAME environment variable'
    task :test do
      Rake::Task['redmine:plugins:test:units'].invoke
      Rake::Task['redmine:plugins:test:functionals'].invoke
      Rake::Task['redmine:plugins:test:integration'].invoke
    end

    namespace :test do
      desc 'Runs the plugins unit tests.'
      Rake::TestTask.new :units => 'db:test:prepare' do |t|
        t.libs << 'test'
        t.verbose = true
        t.pattern = "#{PluginManager.plugins_path_pattern(ENV['NAME'])}/test/unit/**/*_test.rb"
      end

      desc 'Runs the plugins functional tests.'
      Rake::TestTask.new :functionals => 'db:test:prepare' do |t|
        t.libs << 'test'
        t.verbose = true
        t.pattern = "#{PluginManager.plugins_path_pattern(ENV['NAME'])}/test/functional/**/*_test.rb"
      end

      desc 'Runs the plugins integration tests.'
      Rake::TestTask.new :integration => 'db:test:prepare' do |t|
        t.libs << 'test'
        t.verbose = true
        t.pattern = "#{PluginManager.plugins_path_pattern(ENV['NAME'])}/test/integration/**/*_test.rb"
      end

      desc 'Runs the plugins ui tests.'
      Rake::TestTask.new :ui => 'db:test:prepare' do |t|
        t.libs << 'test'
        t.verbose = true
        t.pattern = "#{PluginManager.plugins_path_pattern(ENV['NAME'])}/test/ui/**/*_test.rb"
      end
    end

  end
end

PluginManager.load_rake_tasks
