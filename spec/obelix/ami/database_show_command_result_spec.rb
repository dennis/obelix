require 'spec_helper'

module Obelix
  module AMI
    describe DatabaseShowCommandResult do
      let(:packet) { double(Packet) }
      let(:good_response) do
        r = double(Response)
        allow(r).to receive(:[]).with("response").and_return("Follows")
        allow(r).to receive(:packet).and_return(packet)
        r
      end

      let(:bad_response) do
        r = double(Response)
        allow(r).to receive(:[]).with("response").and_return("ERROR")
        r
      end

      subject(:success_subject) { DatabaseShowCommandResult.new(good_response) }
      subject(:error_subject) { DatabaseShowCommandResult.new(bad_response) }

      it_behaves_like 'a command result'

      context "#each" do
        let(:lines) { ["/test/key                                         : 2016-02-07 01:22:31 +0100\n/test/key2                                        : 42                       \n2 results found.\n--END COMMAND--\r\n"] }

        before { allow(packet).to receive(:unparsed_lines).and_return(lines) }

        it { expect { |b| success_subject.each(&b) }.to yield_control.twice }
        it { expect { |b| success_subject.each(&b) }.to yield_successive_args(["test","key","2016-02-07 01:22:31 +0100"], ["test","key2","42"]) }
      end
    end
  end
end
