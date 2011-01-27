class RuleOfSuccessionEstimator

  attr_reader :freqs

  def initialize
    @freqs = Hash.new(0)
    @total_tokens = 0
  end

  def build_model_from tweets
    tweets.each do |tweet|
      tweet.each do |token|
        @freqs[token] += 1
        @total_tokens += 1
      end
    end
  end

  def all_tokens_in_test_set tokens
    @total_num_uniq_tokens = (@freqs.keys + tokens).uniq.size
  end

  def estimated_prob_of token
    freq = @freqs[token] || 0
    (freq+1).to_f / @total_num_uniq_tokens
  end
  
end
