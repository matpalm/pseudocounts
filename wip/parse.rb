#!/usr/bin/env ruby

records = []

STDIN.each do |line|
  cols = line.chomp.split
  num = cols.shift
  sales = cols.shift
  shirt = cols[0,cols.length-1]
  records << [shirt.join(' '), sales]
end

puts "<table>"

half_way = records.length/2
(0...half_way).each do |idx|
  print "<tr>"
  records[idx].each {|e| print "<td>#{e}</td>"}
  records[half_way+idx].each {|e| print "<td>#{e}</td>"}
  print "<tr>\n"
end

puts "</table>"
