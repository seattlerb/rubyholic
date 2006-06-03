# -*- ruby -*-

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

namespace :rails do
  namespace :freeze do
    desc "Lock to a specific rails version. Defaults to 1.1.2 or specify with RELEASE=x.y.z"
    task :version do
      rel = ENV['RELEASE'] || '1.1.2'
      tag = 'rel_' + rel.split(/[.-]/).join('-')
      rails_svn = "http://dev.rubyonrails.org/svn/rails/tags/#{tag}"
      
      rm_rf   "vendor/rails"
      mkdir_p "vendor/rails"
      
      for framework in %w( railties actionpack activerecord actionmailer activesupport actionwebservice )
        system "svn export #{rails_svn}/#{framework} vendor/rails/#{framework}"
      end
    end
  end
end

Rake::TestTask.new(:u) do |t|
  t.libs << "test"
  t.pattern = 'test/unit/**/*_test.rb'
  t.verbose = true
end

Rake::TestTask.new(:f) do |t|
  t.libs << "test"
  t.pattern = 'test/functional/**/*_test.rb'
  t.verbose = true
end
