require 'spec_helper'

module Obelix
  module AMI
    describe Protocol do
      let(:read_data) { "data" }
      let(:transport) do
        transport = double(TCPTransport, connect: nil, write: nil)
        allow(transport).to receive(:read).and_return("Asterisk Call Manager", read_data)
        transport
      end
      let(:bytes) { double("Packet as string") }
      let(:hostname) { double }
      let(:parser) { double(AmiParser) }
      subject { Protocol.new(transport: transport, parser: parser) }

      context "#connect" do
        context "transport" do
          after { subject.connect(hostname) }

          it { expect(transport).to receive(:connect).with(hostname) }
          it { expect(transport).to receive(:read) }
        end

        context "if greeting line is incorrect" do
          let(:transport) { double(TCPTransport, connect: nil, read: "BAD Stuff") }

          it { expect{subject.connect(hostname)}.to raise_error(RuntimeError) }
        end
      end

      context "#write" do
        let(:action_id) { 42 }
        let(:parser) { double(AmiParser, assemble: bytes) }
        let(:packet) do
          packet = double(Packet)
          allow(packet).to receive(:[]).with("ActionID").and_return(action_id)
          packet
        end

        context "parser" do
          after { subject.write(packet) }

          it { expect(parser).to receive(:assemble).with(packet) }
        end

        context "transport" do
          after { subject.write(packet) }

          it { expect(transport).to receive(:write).with(bytes) }
        end
      end

      context "#read" do
        subject { Protocol.new(transport: transport, parser: parser) }

        # FIXME - tests needs to be rewritten for #read
        let(:parser) { double(AmiParser, parse: nil) }

        it { expect(subject.read).to be_nil }

        context "transport" do
          after { subject.read }
          it { expect(transport).to receive(:read) }
        end

        context "parser; if data available" do
          let(:response_packet) { double(:event? => false, :[] => "42") }
          after { subject.read }
          before { allow(parser).to receive(:parse).with(read_data).and_yield(response_packet) }

          it { expect(parser).to receive(:parse) }
        end

        context "parser; if not data available" do
          let(:transport) { double(TCPTransport, read: "") }

          after { subject.read }

          it { expect(parser).to receive(:parse).at_most(0) }
        end
      end
    end
  end
end
