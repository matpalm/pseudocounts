#!/usr/bin/env ruby
require 'raw_token_freq'
require 'rule_of_succession'

class Runner

  attr_reader :test

  def assign_test_set test_set
    @test = RawTokenFreq.new
    @test.build_model_from test_set
  end

  def assign_model_set model_set
    @model_set = model_set
  end
  
  def test_estimator estimator
    puts "testing estimator #{estimator.class}"

    estimator.build_model_from @model_set
    estimator.all_tokens_in_test_set @test.tokens

    sqr_err_sum = 0.0
    count = num_zeros = 0

    @test.tokens.each do |token|

      estimate_freq_based_on_first_half = estimator.estimated_freq_of token
      actual_freq = @test.freq_of token

      num_zeros += 1 if estimate_freq_based_on_first_half == 0

      err = estimate_freq_based_on_first_half - actual_freq
      sqr_err_sum += err * err
      count += 1

      # printf "%30s %0.6f %0.6f\n", token, estimate_freq_based_on_first_half, actual_freq

    end

    mean_sqr_err = sqr_err_sum / count
    root_mean_sqr_err = Math.sqrt(mean_sqr_err)

    puts "total tokens checked = #{@test.tokens.size}"
    puts "RMSE = #{root_mean_sqr_err}"

    percent_num_zeros = (num_zeros.to_f / @test.tokens.size * 100).to_i
    puts "num zeros from estimate = #{num_zeros} (#{percent_num_zeros}%)"

  end
  
end

tweets = STDIN.map { |line| line.chomp.split }

runner = Runner.new
runner.assign_test_set tweets.slice(tweets.length*0.5, tweets.size)
runner.assign_model_set tweets.slice(0, tweets.length*0.5) 

runner.test_estimator RawTokenFreq.new
runner.test_estimator RuleOfSuccession.new
