require 'spec_helper'

module Obelix
  module AMI
    module AMIActions
      describe DatabaseDeltree do
        let(:family) { 'family' }
        let(:client) { double(Client, login: false, write: false, read_response: response) }
        let(:packet) { double(Packet) }
        let(:response_packet) { double(Packet, unparsed_lines: ["1 database entries removed.\n--END COMMAND--\r\n"]) }
        let(:response) do
          response = double(Response)
          allow(response).to receive(:[]).with("response").and_return('Follows')
          allow(response).to receive(:packet).and_return(response_packet)
          response
        end

        subject { DatabaseDeltree.new(client, family) }

        before { allow(Action).to receive(:create).and_return(packet) }

        context "client" do
          after { subject.execute }

          it { expect(client).to receive(:write).with(packet) }
          it { expect(client).to receive(:read_response) }
        end

        context "should create correct action" do
          after { subject.execute }

          it { expect(Action).to receive(:create).with("command", { "command" => "database deltree \"#{family}\"" }) }
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

          context "if database entries does not exist, then it be a successful action" do
            let(:response_packet) { double(Packet, unparsed_lines: ["Database entries do not exists\n--END COMMAND--\r\n"]) }
            it { expect(subject.execute).to be_instance_of(CommandResult) }
            it { expect(CommandResult).to receive(:new).with(true); subject.execute }
          end
        end
      end
    end
  end
end
