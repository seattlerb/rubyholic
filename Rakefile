# -*- ruby -*-

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

task :rails do
  tag = 'rel_1-1-2'
  rails_svn = "http://dev.rubyonrails.org/svn/rails/tags/#{tag}"

  rm_rf   "vendor/rails"
  mkdir_p "vendor/rails"
  
  for framework in %w( railties actionpack activerecord actionmailer activesupport actionwebservice )
    system "svn export #{rails_svn}/#{framework} vendor/rails/#{framework}"
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
