require 'spec_helper'

module Obelix
  module AMI
    describe ClientActions do
      let(:client) { double(Client) }
      let(:response) { double(CommandResult) }
      let(:action) { double('Action', execute: response) }

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

      context "#database_del" do
        let(:family) { 'family' }
        let(:key) { 'key' }

        before { allow(AMIActions::DatabaseDel).to receive(:new).and_return(action) }

        after { subject.database_del(client, family, key) }

        it { expect(AMIActions::DatabaseDel).to receive(:new).with(client, family, key) }
        it { expect(action).to receive(:execute) }
        it { expect(subject.database_del(client, family, key)).to eql(response) }
      end

      context "#database_deltree" do
        let(:family) { 'family' }

        before { allow(AMIActions::DatabaseDeltree).to receive(:new).and_return(action) }

        after { subject.database_deltree(client, family) }

        it { expect(AMIActions::DatabaseDeltree).to receive(:new).with(client, family) }
        it { expect(action).to receive(:execute) }
        it { expect(subject.database_deltree(client, family)).to eql(response) }
      end

      context "#database_put" do
        let(:family) { 'family' }
        let(:key) { 'key' }
        let(:value) { 'value' }

        before { allow(AMIActions::DatabasePut).to receive(:new).and_return(action) }

        after { subject.database_put(client, family, key, value) }

        it { expect(AMIActions::DatabasePut).to receive(:new).with(client, family, key, value) }
        it { expect(action).to receive(:execute) }
        it { expect(subject.database_put(client, family, key, value)).to eql(response) }
      end

      context "#database_show" do
        before { allow(AMIActions::DatabaseShow).to receive(:new).and_return(action) }

        after { subject.database_show(client) }

        it { expect(AMIActions::DatabaseShow).to receive(:new).with(client) }
        it { expect(action).to receive(:execute) }
        it { expect(subject.database_show(client)).to eql(response) }
      end
    end
  end
end
