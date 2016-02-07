require 'spec_helper'

module Obelix
  module AMI
    module AMIActions
      describe Login do
        let(:username) { 'username' }
        let(:secret) { 'secret' }
        let(:client) { double(Client, login: false, write: false, read_response: response) }
        let(:packet) { double(Packet) }
        let(:response) do
          response = double(Response)
          allow(response).to receive(:[]).with("response").and_return('Success')
          response
        end

        subject { Login.new(client, username, secret) }

        context "#login" do
          before { allow(Action).to receive(:create).and_return(packet) }

          context "client" do
            after { subject.execute }

            it { expect(client).to receive(:write).with(packet) }
            it { expect(client).to receive(:read_response) }
          end

          context "should create correct action" do
            after { subject.execute }

            it { expect(Action).to receive(:create).with("Login", { "Username" => username, "Secret" => secret }) }
          end

          context "result" do
            context "if success, result" do
              it { expect(subject.execute).to be_instance_of(CommandResult) }
              it { expect(CommandResult).to receive(:new).with(true); subject.execute }
            end

            context "if not success, result" do
              before { allow(response).to receive(:[]).with("response").and_return('Error') }

              it { expect(subject.execute).to be_instance_of(CommandResult) }
              it { expect(CommandResult).to receive(:new).with(false); subject.execute }
            end
          end
        end
      end
    end
  end
end


