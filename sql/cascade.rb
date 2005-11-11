#!/usr/local/bin/ruby -w

db_name = ARGV.shift

tables = []
`echo "\\dt" | psql #{db_name}`.each_line do |line|
  next unless line =~ /table/
  tables << line.split(/\s*\|\s*/)[1]
end

tables.each do |table|

  `echo "\\d #{table}" | psql rubyholic_test`.each_line do |line|

    next unless line =~ /(\S+) FOREIGN KEY \((\S+)\) REFERENCES (\S+)/
    
    index, column, ref = $1, $2, $3

    puts %(ALTER TABLE #{table} DROP CONSTRAINT #{index};)
    puts %(ALTER TABLE #{table} ADD FOREIGN KEY (#{column}) REFERENCES #{ref} ON DELETE CASCADE;)

  end
end
