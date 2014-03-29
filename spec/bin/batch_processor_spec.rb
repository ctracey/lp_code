require 'spec_helper'

describe "batch processor" do

  it 'runs and logs to the console' do
    console_output = `./bin/batch_processor.rb`
    console_output.include?('running batch process').should be_true
  end
end
