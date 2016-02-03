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
        after { subject.login(client, username, secret) }

        it { expect(Action).to receive(:create).with("Login", { "Username" => username, "Secret" => secret }) }
        it { expect(client).to receive(:write).with(packet) }
        it { expect(client).to receive(:read_response) }

        context "if successl" do
          after {}

          it { expect(subject.login(client, username, secret)).to eql(true) }
        end

        context "if not success" do
          after {}
          before { allow(response).to receive(:[]).with("response").and_return('Error') }

          it { expect(subject.login(client, username, secret)).to eql(false) }
        end
      end
    end
  end
end
