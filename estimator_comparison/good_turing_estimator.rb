class GoodTuringEstimator
  attr_reader :freqs, :total_tokens, :num_unseen_entries

  def build_model_from tweets
    calc_freq_from tweets 
    build_freq_of_freqs_table
    write_d_sgt_input_to d_sgt_input_file
    run_d_sgt
  end

  def calc_freq_from tweets
    @freqs = Hash.new(0)
    tweets.each do |tweet|
      tweet.each do |token|
        @freqs[token] += 1
      end
    end
  end

  def build_freq_of_freqs_table
    @freq_of_freqs = Hash.new(0)
    @freqs.each do |token,freq|
      @freq_of_freqs[freq] += 1
    end
  end

  def write_d_sgt_input_to filename
    out = File.open(filename, 'w')
    fof_sorted_by_freq = @freq_of_freqs.to_a.sort{|a,b| a[0]<=>b[0]}
    fof_sorted_by_freq.each do |freq_and_freq_of_freq|
      freq, freq_of_freq = freq_and_freq_of_freq
      out.puts "#{freq}\t#{freq_of_freq}"
    end
    out.close
  end

  def d_sgt_input_file
    "/tmp/d_sgt.#{$$}.input"
  end

  def run_d_sgt

    cmd = "./D_SGT <#{d_sgt_input_file}"
    result = `#{cmd}`
    #puts ">run d sgt cmd=#{cmd} exit=#{$?} #{$?.exitstatus}"
    #!!! process returns 1 on success :( raise "couldn't run d_sgt #{result}" unless $?.to_s=='256' # should be .success?
   
    @freq_to_estimate_prob = {}
    result.split("\n").each do |line|
      freq, estimated_prob = line.chomp.split
      @freq_to_estimate_prob[freq.to_i] = estimated_prob.to_f
    end
  end

  def all_tokens_in_test_set tokens
    @num_unseen_entries = (tokens - @freqs.keys).size
  end
  
  def estimated_prob_of token
    freq = @freqs[token]
    estimate = @freq_to_estimate_prob[freq]
    estimate /= @num_unseen_entries if freq == 0
    estimate
  end

end


