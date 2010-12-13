#!/usr/bin/env ruby
require 'irb_rc'
require 'dereference_url_shorteners'

@url_utils = DereferenceUrlShorteners.new

@mongo.find.each do |tweet|

  url_targets = {}
  tweet["entities"]["urls"].reverse.each do |url_info|
    url = url_info['url']
    target = @url_utils.final_target_of url
    target_domain = @url_utils.domain_of target
    url_targets[url] = "[#{target_domain}]"
  end

  id, tokens = tweet['id'], tweet['text_tokens'].flatten
  tokens_without_urls = tokens.map do |token|
    if url_targets.has_key?(token) 
      url_targets[token]
    else 
      token.downcase
    end
  end
  puts tokens_without_urls.join(" ")

end
