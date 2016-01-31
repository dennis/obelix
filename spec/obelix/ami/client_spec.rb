require 'spec_helper'

module Obelix
  module AMI
    describe Client do
      let(:read_data) { "data" }
      let(:transport) do
        transport = double(TCPTransport, connect: nil, write: nil)
        allow(transport).to receive(:read).and_return("Asterisk Call Manager", read_data)
        transport
      end
      let(:bytes) { double("Packet as string") }
      let(:hostname) { double }
      let(:username) { double }
      let(:secret) { double }
      let(:parser) { double(AmiParser) }
      subject { Client.new(transport: transport, parser: parser) }

      context "#connect" do
        context "transport" do
          after { subject.connect(hostname, username, secret) }

          it { expect(transport).to receive(:connect).with(hostname, username, secret) }
          it { expect(transport).to receive(:read) }
        end

        it { expect(subject.connect(hostname, username, secret)).to eql(subject) }

        context "if greeting line is incorrect" do
          let(:transport) { double(TCPTransport, connect: nil, read: "BAD Stuff") }

          it { expect{subject.connect(hostname, username, secret)}.to raise_error(RuntimeError) }
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

        it { expect(subject.write(packet)).to eql(action_id.to_s) }

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
        subject { Client.new(transport: transport, parser: parser).connect(hostname, username, secret) }

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
          let(:read_data) { "" }
          after { subject.read }
          it { expect(parser).to receive(:parse).at_most(0) }
        end
      end

      context "#read_response" do
        # FIXME - tests needs to be rewritten for #read_response
        let(:parser) { double(AmiParser, parse: nil) }

        context "if nothing is read" do
          it { expect(subject.read_response).to be_nil }
          it { expect(parser).to receive(:parse).at_most(0) }
        end

        context "if response is available" do
          let(:packet) do
            packet = double
            allow(packet).to receive(:[]).with("ActionID").and_return(action_id)
            packet
          end
          before do
            subject.write(packet)
          end

        end
      end
    end
  end
end
