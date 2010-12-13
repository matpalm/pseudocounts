#!/usr/bin/env ruby
require 'irb_rc'
@mongo.find.each do |tweet|
  puts tweet['text']
end
