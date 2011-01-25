require 'raw_token_freq.rb'

describe RawTokenFreq do

  before do
    @rtf = RawTokenFreq.new
    @rtf.build_model_from [%w{the cat sat}, %w{on the mat}]
    @rtf.all_tokens_in_test_set %w{the fred}
  end

  it 'should report estimated freq as exact frequency for tokens in training set' do
    @rtf.estimated_freq_of('the').should == 2.0 / 6
  end

  it 'should report zero for terms only in test set' do
    @rtf.estimated_freq_of('freq').should == 0.0
  end

end
