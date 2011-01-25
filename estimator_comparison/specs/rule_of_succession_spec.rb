require 'rule_of_succession.rb'

describe RuleOfSuccession do

  before do
    @ros = RuleOfSuccession.new
    @ros.build_model_from [%w{the cat sat}, %w{on the mat}]
    @ros.all_tokens_in_test_set %w{the fred}
  end

  it 'should add 1 to frequency of terms in training set' do
    @ros.estimated_freq_of('the').should == 3.0 / 6
  end

  it 'should estimate 1/nth frequency for terms not in training set' do
    @ros.estimated_freq_of('freq').should == 1.0 / 6
  end

end
