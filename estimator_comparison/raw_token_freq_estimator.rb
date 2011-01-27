
class RawTokenFreqEstimator
  attr_reader :freqs, :total_tokens

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

  def tokens
    @freqs.keys
  end

  def unique_tokens
    @freqs.keys.size
  end

  def all_tokens_in_test_set tokens
  end

  def estimated_prob_of token
    freq_of token
  end

  def freq_of token
    if @freqs.has_key? token
      @freqs[token] / @total_tokens.to_f
    else
      0
    end
  end
  
end
