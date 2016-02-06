require 'spec_helper'

module Obelix
  module AMI
    describe Client do
      let(:read_data) { "data" }
      let(:bytes) { double("Packet as string") }
      let(:hostname) { double }
      let(:protocol) { double(Protocol, add_event_listener: nil, add_response_listener: nil, connect: nil, write: nil) }
      let(:actions) { double(ClientActions, :client= => nil) }
      subject { Client.new(protocol: protocol, actions: actions) }

      context "#initialize" do
        after { subject }
        context "add event listener" do
          it { expect(protocol).to receive(:add_event_listener) }
        end
        context "add response listener" do
          it { expect(protocol).to receive(:add_response_listener) }
        end
      end

      context "#connect" do
        context "protocol" do
          after { subject.connect(hostname) }

          it { expect(protocol).to receive(:connect).with(hostname) }
        end

        it { expect(subject.connect(hostname)).to eql(subject) }
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

        context "protocol" do
          after { subject.write(packet) }

          it { expect(protocol).to receive(:write).with(packet) }
        end
      end

      context "#read_response" do
        pending
      end

      context "#events" do
        pending
      end

      context "actions" do
        let(:username) { 'username' }
        let(:secret) { 'secret' }
        let(:response) { double(CommandResult, :success! => nil) }

        before {
          allow(actions).to receive(:login).and_return(response)
        }

        context "#login" do
          after { subject.login(username, secret) }

          context "is proxied to ClientActions" do
            it { expect(actions).to receive(:login).with(subject, username, secret) }
          end

          it { expect(subject.login(username, secret)).to eql(response) }

          context "invokes success!" do
            it { expect(response).not_to receive(:success!) }
          end
        end

        context "#login!" do
          after { subject.login!(username, secret) }

          context "is proxied to ClientActions" do
            it { expect(actions).to receive(:login).with(subject, username, secret) }
          end

          it { expect(subject.login(username, secret)).to eql(response) }

          context "invokes success!" do
            it { expect(response).to receive(:success!) }
          end
        end
      end
    end
  end
end
