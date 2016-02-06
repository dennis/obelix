require 'spec_helper'

module Obelix
  module AMI
    describe ClientActions do
      let(:username) { 'username' }
      let(:secret) { 'secret' }
      let(:client) { double(Client, login: false, write: false, read_response: response) }
      let(:packet) { double(Packet) }
      let(:response) do
        response = double(Response)
        allow(response).to receive(:[]).with("response").and_return('Success')
        response
      end

      context "#login" do
        before { allow(Action).to receive(:create).and_return(packet) }

        context "client" do
          after { subject.login(client, username, secret) }
          it { expect(client).to receive(:write).with(packet) }
          it { expect(client).to receive(:read_response) }
        end

        context "should create correct action" do
          after { subject.login(client, username, secret) }

          it { expect(Action).to receive(:create).with("Login", { "Username" => username, "Secret" => secret }) }
        end

        context "result" do
          after { subject.login(client, username, secret) }

          context "if success, result" do
            it { expect(subject.login(client, username, secret)).to be_instance_of(CommandResult) }
            it { expect(CommandResult).to receive(:new).with(true) }
          end

          context "if not success, result" do
            before { allow(response).to receive(:[]).with("response").and_return('Error') }

            it { expect(subject.login(client, username, secret)).to be_instance_of(CommandResult) }
            it { expect(CommandResult).to receive(:new).with(false) }
          end
        end
      end
    end
  end
end
