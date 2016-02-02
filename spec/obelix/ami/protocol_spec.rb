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
        let(:parser) { double(AmiParser, parse: [event]) }
        subject { Protocol.new(transport: transport, parser: parser) }
        after { subject.read }

        context "from transport" do
          let(:parser) { double(AmiParser, parse: []) }
          context "read data" do
            it { expect(transport).to receive(:read) }
          end

          context "parse data returned" do
            let(:read_data) { 'asdf' }
            let(:transport) { transport = double(TCPTransport, read: read_data) }

            it { expect(parser).to receive(:parse).with(read_data) }
          end
        end

        context "invoke listeners" do
          context "for event listener" do
            let(:event) { double(Event, event?: true) }

            it "event listener fired if event packet" do
              listener_fired = false
              subject.add_event_listener { listener_fired = true }
              subject.read

              expect(listener_fired).to be true
            end

            it "no listener fired if response packet" do
              allow(event).to receive(:event?).and_return(false)

              listener_fired = false
              subject.add_event_listener { listener_fired = true }
              subject.read

              expect(listener_fired).to be false
            end
          end

          context "for response listener" do
            let(:event) { double(Event, event?: false) }

            it "response listener fired if event response" do
              listener_fired = false
              subject.add_response_listener { listener_fired = true }
              subject.read

              expect(listener_fired).to be true
            end

            it "no listener fired if event packet" do
              allow(event).to receive(:event?).and_return(true)

              listener_fired = false
              subject.add_event_listener { listener_fired = true }
              subject.read

              expect(listener_fired).to be true
            end
          end
        end
      end
    end
  end
end
