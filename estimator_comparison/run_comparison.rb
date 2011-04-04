#!/usr/bin/env ruby
require 'raw_token_freq_estimator'
require 'rule_of_succession_estimator'
require 'good_turing_estimator'
require 'array_split'

class Runner

  attr_reader :test

  def test_set= test_set
    @test = RawTokenFreqEstimator.new
    @test.build_model_from test_set
  end

  def training_set= training_set
    @training_set = training_set
  end
  
  def test_estimator estimator
    estimator.build_model_from @training_set
    estimator.all_tokens_in_test_set @test.tokens

    sqr_err_sum = 0.0
    count = num_zeros = 0

    printf "ESTIMATE %30s %8s %8s\n", 'token', 'est_fr', 'act_fr'
    @test.tokens.each do |token|

      estimate_freq_based_on_model = estimator.estimated_prob_of token
      actual_freq = @test.freq_of token

      num_zeros += 1 if estimate_freq_based_on_model == 0

      err = estimate_freq_based_on_model - actual_freq
      sqr_err_sum += err * err
      count += 1

      printf "ESTIMATE %30s %0.6f %0.6f\n", token, estimate_freq_based_on_model, actual_freq

    end

    mean_sqr_err = sqr_err_sum / count
    root_mean_sqr_err = Math.sqrt(mean_sqr_err)

    #puts "estimator #{estimator.class}"
    #puts "total tokens checked = #{@test.tokens.size}"
    #puts "RMSE = #{root_mean_sqr_err}"
    puts "#{estimator.class}\t#{root_mean_sqr_err}\t#{num_zeros}"

    percent_num_zeros = (num_zeros.to_f / @test.tokens.size * 100).to_i
    #puts "num zeros from estimate = #{num_zeros} (#{percent_num_zeros}%)"

  end
  
end

tweets = STDIN.map { |line| line.chomp.split }
training_set, test_set = tweets.split_randomly(0.8)

runner = Runner.new
runner.training_set = training_set
runner.test_set = test_set

runner.test_estimator RawTokenFreqEstimator.new
runner.test_estimator RuleOfSuccessionEstimator.new
runner.test_estimator GoodTuringEstimator.new

raise 'todos'

=begin
add entries from training set
for each test set entry
 add entry
 run estimator
 remove entry

compare to raw frequency from entire set

=end
