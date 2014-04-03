require "spec_helper"

describe "batch processor" do

  let(:command) { "./bin/batch_processor" }
  let(:destinations_path) { "./spec/fixtures/destinations.xml"}
  let(:taxonomy_path) { "./spec/fixtures/taxonomy.xml"}

  it "runs and logs to the console" do
    console_output = `#{command} #{destinations_path} #{taxonomy_path}`
    console_output.include?("running batch process").should be_true
  end

  context "destinations parameter" do

    let(:hide_output) { " > /dev/null" }

    it "accepts the path to an xml file as destinations parameter" do
      system("#{command} #{destinations_path} #{taxonomy_path} #{hide_output}").should be_true
    end

    it "accepts the path to an xml file as taxonomy parameter" do
      system("#{command} #{destinations_path} #{taxonomy_path} #{hide_output}").should be_true
    end

    context "no parameter provided" do
      it "the exit code is 1" do
        system(command).should be_false
      end
    end

  end

  context "options" do
    describe "help option" do

      let(:console_output) { `#{command} -h` }

      it "describes the destinations parameter" do
        console_output.include?("DESTINATIONS_PATH             Path to xml with destinations content").should be_true
      end

      it "describes the taxonomy parameter" do
        console_output.include?("TAXONOMY_PATH                 Path to xml with destination taxonomy").should be_true
      end

      it "describes the max_batches parameter" do
        console_output.include?("[MAX_BATCHES]                 Optional, maximum number of batch processes to spawn. Defaults to 20").should be_true
      end

      it "describes the version option" do
        console_output.include?("-v, --version                 show version").should be_true
      end

      it "describes the help option" do
        console_output.include?("-h, --help                    print help").should be_true
      end

    end
  end
end
