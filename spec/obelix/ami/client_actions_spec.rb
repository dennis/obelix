require 'spec_helper'

module Obelix
  module AMI
    describe ClientActions do
      let(:client) { double(Client) }

      context "#login" do
        let(:username) { 'username' }
        let(:secret) { 'secret' }
        let(:response) { double(CommandResult) }
        let(:action) { double('Login Action', execute: response) }

        before { allow(AMIActions::Login).to receive(:new).and_return(action) }

        after { subject.login(client, username, secret) }

        it { expect(AMIActions::Login).to receive(:new).with(client, username, secret) }
        it { expect(action).to receive(:execute) }
        it { expect(subject.login(client, username, secret)).to eql(response) }
      end
    end
  end
end
