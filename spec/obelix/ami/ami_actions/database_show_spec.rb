require 'spec_helper'

module Obelix
  module AMI
    module AMIActions
      describe DatabaseShow do
        let(:client) { double(Client, login: false, write: false, read_response: response) }
        let(:packet) { double(Packet) }
        let(:response) { double(Response) }

        subject { DatabaseShow.new(client) }

        before { allow(Action).to receive(:create).and_return(packet) }

        context "client" do
          after { subject.execute }

          it { expect(client).to receive(:write).with(packet) }
          it { expect(client).to receive(:read_response) }
        end

        context "should create correct action" do
          after { subject.execute }

          it { expect(Action).to receive(:create).with("command", { "command" => "database show" }) }
        end

        context "result" do
          it { expect(subject.execute).to be_instance_of(DatabaseShowCommandResult) }
          it { expect(DatabaseShowCommandResult).to receive(:new).with(response); subject.execute }
        end
      end
    end
  end
end
