require "spec_helper"

describe "batch processor" do

  let(:command) { "./bin/batch_processor" }
  let(:destinations_path) { "./spec/fixtures/destinations.xml"}

  it "runs and logs to the console" do
    console_output = `#{command} #{destinations_path}`
    console_output.include?("running batch process").should be_true
  end

  context "destinations parameter" do

    let(:hide_output) { " > /dev/null" }

    it "accepts the path to an xml file as destinations parameter" do
      system("#{command} #{destinations_path} #{hide_output}").should be_true
    end

    context "no parameter provided" do
      it "the exit code is 1" do
        system(command).should be_false
      end
    end

  end

  context "options" do
    describe "help option" do

      it "describes the version option" do
        console_output = `#{command} -h`
        console_output.include?("-v, --version                 show version").should be_true
      end

      it "describes the help option" do
        console_output = `#{command} -h`
        console_output.include?("-h, --help                    print help").should be_true
      end

    end
  end
end
