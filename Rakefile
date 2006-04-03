# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

task :rails do
  tag = 'rel_1-1-0'
  rails_svn = "http://dev.rubyonrails.org/svn/rails/tags/#{tag}"

  rm_rf   "vendor/rails"
  mkdir_p "vendor/rails"
  
  for framework in %w( railties actionpack activerecord actionmailer activesupport actionwebservice )
    system "svn export #{rails_svn}/#{framework} vendor/rails/#{framework}"
  end
end
