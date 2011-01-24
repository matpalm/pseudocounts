#!/usr/bin/env ruby

class Tweets
  attr_reader :freqs, :total_tokens

  def initialize
    @freqs = Hash.new(0)
    @total_tokens = 0
  end

  def add tweets
    tweets.each do |tweet|
      tweet.each do |token|
        @freqs[token] += 1
        @total_tokens += 1
      end
    end
  end

  def tokens
    @freqs.keys
  end

  def unique_tokens
    @freqs.keys.size
  end
  
  def freq_of token
    if @freqs.has_key? token
      @freqs[token] / @total_tokens.to_f
    else
      0
    end
  end
  
  def 
end

tweets = STDIN.map { |line| line.chomp.split }

#all_tweets = Tweets.new
#all_tweets.add tweets

first_half = Tweets.new
first_half.add tweets.slice(0, tweets.length*0.9)

second_half = Tweets.new
second_half.add tweets.slice(tweets.length*0.9, tweets.size)

=begin
puts first_half.freqs.inspect
puts first_half.total_tokens.inspect
puts second_half.freqs.inspect
puts second_half.total_tokens.inspect
=end

sqr_err_sum = 0.0
count = 0
num_zeros = 0

second_half.tokens.each do |token|

  estimate_freq_based_on_first_half = first_half.freq_of(token)
  actual_freq = second_half.freq_of(token)

  num_zeros += 1 if estimate_freq_based_on_first_half == 0

  err = estimate_freq_based_on_first_half - actual_freq
  sqr_err_sum += err * err
  count += 1

  printf "%30s %0.3f %0.3f\n", token, estimate_freq_based_on_first_half, actual_freq

end

mean_sqr_err = sqr_err_sum / count
root_mean_sqr_err = Math.sqrt(mean_sqr_err)

puts "total tokens checked = #{second_half.tokens.size}"
puts "RMSE = #{root_mean_sqr_err}"
puts "num zeros from estimate = #{num_zeros}"
