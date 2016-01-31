require 'spec_helper'

module Obelix
  module AMI
    describe Action do
      it_behaves_like "a packet"

      subject { Action.create("Dummy") }

      context "event?" do
        it { expect(subject.event?).to be false }
      end

      context "response?" do
        it { expect(subject.response?).to be false }
      end

      context "self.create w/o options" do
        let(:packet_opts) { { "ActionID" => 1, "Action" => "Dummy" } }

        it { expect(subject).to be_a Action }

        context "Packet" do
          it { expect(Packet).to receive(:new).with(packet_opts); subject }
        end
      end

      context "self.create with options" do
        let(:options) {  { "Option" => "Value" } }
        let(:packet_opts) { { "ActionID" => 1, "Action" => "Dummy", "Option" => "Value" } }

        subject { Action.create("Dummy", options) }

        context "Packet" do
          it { expect(Packet).to receive(:new).with(packet_opts); subject }
        end
      end
    end
  end
end
