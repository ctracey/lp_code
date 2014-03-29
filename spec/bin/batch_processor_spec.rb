require "spec_helper"

describe "batch processor" do

  let(:command) { "./bin/batch_processor" }

  it "runs and logs to the console" do
    console_output = `#{command}`
    console_output.include?("running batch process").should be_true
  end

  context "options" do
    describe "help option" do

      it "describes the version option" do
        console_output = `#{command} -h`
        console_output.include?("    -v, --version                 show version").should be_true
      end

      it "describes the help option" do
        console_output = `#{command} -h`
        console_output.include?("    -h, --help                    print help").should be_true
      end

    end
  end
end
