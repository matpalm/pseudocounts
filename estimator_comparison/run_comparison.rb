#!/usr/bin/env ruby
require 'raw_token_freq_estimator'
require 'rule_of_succession_estimator'
require 'good_turing_estimator'

class Runner

  attr_reader :test

  def assign_test_set test_set
    @test = RawTokenFreqEstimator.new
    @test.build_model_from test_set
  end

  def assign_model_set model_set
    @model_set = model_set
  end
  
  def test_estimator estimator

    estimator.build_model_from @model_set
    estimator.all_tokens_in_test_set @test.tokens

    sqr_err_sum = 0.0
    count = num_zeros = 0

    @test.tokens.each do |token|

      estimate_freq_based_on_model = estimator.estimated_prob_of token
      actual_freq = @test.freq_of token

      num_zeros += 1 if estimate_freq_based_on_model == 0

      err = estimate_freq_based_on_model - actual_freq
      sqr_err_sum += err * err
      count += 1

#      printf "ESTIMATE %30s %0.6f %0.6f\n", token, estimate_freq_based_on_model, actual_freq

    end

    mean_sqr_err = sqr_err_sum / count
    root_mean_sqr_err = Math.sqrt(mean_sqr_err)

    puts "estimator #{estimator.class}"
    puts "total tokens checked = #{@test.tokens.size}"
    puts "RMSE = #{root_mean_sqr_err}"

    percent_num_zeros = (num_zeros.to_f / @test.tokens.size * 100).to_i
    puts "num zeros from estimate = #{num_zeros} (#{percent_num_zeros}%)"

  end
  
end

tweets = STDIN.map { |line| line.chomp.split }

runner = Runner.new
runner.assign_test_set tweets.slice(tweets.length*0.8, tweets.size)
runner.assign_model_set tweets.slice(0, tweets.length*0.8) 

runner.test_estimator RawTokenFreqEstimator.new
runner.test_estimator RuleOfSuccessionEstimator.new
runner.test_estimator GoodTuringEstimator.new
