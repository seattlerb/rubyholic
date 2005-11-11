# -*- ruby -*-
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

$VERBOSE = nil

desc "Run all the tests"
task :default => :test

task :test => [ :test_unit, :test_functional ]

task :init => [:rails, :dbs, :rude]

task :rails do
  Dir.chdir("vendor") do
    unless test ?d, 'rails' then
      sh 'svn co http://dev.rubyonrails.org/svn/rails/trunk rails'
      # sh 'patch -p1 < real_unit_testing.diff'
    end
  end
end

task :dbs => :environment do
  abcs = ActiveRecord::Base.configurations

  abcs.each do |env,setup|
    system "dropdb #{setup['database']}"
  end

  sleep 1

  abcs.each do |env,setup|
    sh "createdb #{setup['database']}"
    sleep 1
  end
  sh 'sync'
end

task :rude => [ :import, :clone_structure_to_test ]

task :import do
  sh 'psql -f sql/rubyholic.sql rubyholic_development'
  sleep 1
  sh 'sync'
  sh './sql/cascade.rb rubyholic_development | psql rubyholic_development'
end

desc 'Require application environment.'
task :environment do
  unless defined? RAILS_ROOT
    require File.dirname(__FILE__) + '/config/environment'
  end
end

desc "Run the unit tests in test/unit"
Rake::TestTask.new("test_unit") { |t|
  t.libs << "test"
  t.pattern = 'test/unit/**/test_*.rb'
  t.verbose = true
}

desc "Run the functional tests in test/functional"
Rake::TestTask.new("test_functional") { |t|
  t.libs << "test"
  t.pattern = 'test/functional/**/test_*.rb'
  t.verbose = true
}

desc "Report code statistics (KLOCs, etc) from the application"
task :stats => [ :environment ] do
  require 'code_statistics'
  CodeStatistics.new(
    ["Helpers", "app/helpers"], 
    ["Controllers", "app/controllers"], 
    ["APIs", "app/apis"],
    ["Components", "components"],
    ["Functionals", "test/functional"],
    ["Models", "app/models"],
    ["Units", "test/unit"]
  ).to_s
end

desc "Recreate the test databases from the development structure"
task :clone_structure_to_test => [ :db_structure_dump, :purge_test_database ] do
  abcs = ActiveRecord::Base.configurations
  case abcs["test"]["adapter"]
    when  "mysql"
      ActiveRecord::Base.establish_connection(:test)
      ActiveRecord::Base.connection.execute('SET foreign_key_checks = 0')
      IO.readlines("db/#{RAILS_ENV}_structure.sql").join.split("\n\n").each do |table|
        ActiveRecord::Base.connection.execute(table)
      end
    when "postgresql"
      ENV['PGHOST']     = abcs["test"]["host"] if abcs["test"]["host"]
      ENV['PGPORT']     = abcs["test"]["port"].to_s if abcs["test"]["port"]
      ENV['PGPASSWORD'] = abcs["test"]["password"].to_s if abcs["test"]["password"]
      `psql -U "#{abcs["test"]["username"]}" -f db/#{RAILS_ENV}_structure.sql #{abcs["test"]["database"]}`
    when "sqlite", "sqlite3"
      `#{abcs[RAILS_ENV]["adapter"]} #{abcs["test"]["dbfile"]} < db/#{RAILS_ENV}_structure.sql`
    when "sqlserver"
      `osql -E -S #{abcs["test"]["host"]} -d #{abcs["test"]["database"]} -i db\\#{RAILS_ENV}_structure.sql`
    else 
      raise "Unknown database adapter '#{abcs["test"]["adapter"]}'"
  end
end

desc "Dump the database structure to a SQL file"
task :db_structure_dump => :environment do
  abcs = ActiveRecord::Base.configurations
  case abcs[RAILS_ENV]["adapter"] 
    when "mysql"
      ActiveRecord::Base.establish_connection(abcs[RAILS_ENV])
      File.open("db/#{RAILS_ENV}_structure.sql", "w+") { |f| f << ActiveRecord::Base.connection.structure_dump }
    when "postgresql"
      ENV['PGHOST']     = abcs[RAILS_ENV]["host"] if abcs[RAILS_ENV]["host"]
      ENV['PGPORT']     = abcs[RAILS_ENV]["port"].to_s if abcs[RAILS_ENV]["port"]
      ENV['PGPASSWORD'] = abcs[RAILS_ENV]["password"].to_s if abcs[RAILS_ENV]["password"]
      `pg_dump -U "#{abcs[RAILS_ENV]["username"]}" -s -x -O -f db/#{RAILS_ENV}_structure.sql #{abcs[RAILS_ENV]["database"]}`
    when "sqlite", "sqlite3"
      `#{abcs[RAILS_ENV]["adapter"]} #{abcs[RAILS_ENV]["dbfile"]} .schema > db/#{RAILS_ENV}_structure.sql`
    when "sqlserver"
      `scptxfr /s #{abcs[RAILS_ENV]["host"]} /d #{abcs[RAILS_ENV]["database"]} /I /f db\\#{RAILS_ENV}_structure.sql /q /A /r`
      `scptxfr /s #{abcs[RAILS_ENV]["host"]} /d #{abcs[RAILS_ENV]["database"]} /I /F db\ /q /A /r`
    else 
      raise "Unknown database adapter '#{abcs["test"]["adapter"]}'"
  end
end

desc "Empty the test database"
task :purge_test_database => :environment do
  abcs = ActiveRecord::Base.configurations
  case abcs["test"]["adapter"]
    when "mysql"
      ActiveRecord::Base.establish_connection(:test)
      ActiveRecord::Base.connection.recreate_database(abcs["test"]["database"])
    when "postgresql"
      ENV['PGHOST']     = abcs["test"]["host"] if abcs["test"]["host"]
      ENV['PGPORT']     = abcs["test"]["port"].to_s if abcs["test"]["port"]
      ENV['PGPASSWORD'] = abcs["test"]["password"].to_s if abcs["test"]["password"]
      `dropdb -U "#{abcs["test"]["username"]}" #{abcs["test"]["database"]}`
      `createdb -T template0 -U "#{abcs["test"]["username"]}" #{abcs["test"]["database"]}`
    when "sqlite","sqlite3"
      File.delete(abcs["test"]["dbfile"]) if File.exist?(abcs["test"]["dbfile"])
    when "sqlserver"
      dropfkscript = "#{abcs["test"]["host"]}.#{abcs["test"]["database"]}.DP1".gsub(/\\/,'-')
      `osql -E -S #{abcs["test"]["host"]} -d #{abcs["test"]["database"]} -i db\\#{dropfkscript}`
      `osql -E -S #{abcs["test"]["host"]} -d #{abcs["test"]["database"]} -i db\\#{RAILS_ENV}_structure.sql`
    else 
      raise "Unknown database adapter '#{abcs["test"]["adapter"]}'"
  end
end

desc "Clears all *.log files in log/"
task :clear_logs => :environment do
  FileList["log/*.log"].each do |log_file|
    f = File.open(log_file, "w")
    f.close
  end
end

desc "Migrate the database according to the migrate scripts in db/migrate (only supported on PG/MySQL). A specific version can be targetted with VERSION=x"
task :migrate => :environment do
  ActiveRecord::Migrator.migrate(File.dirname(__FILE__) + '/db/migrate/', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
end
