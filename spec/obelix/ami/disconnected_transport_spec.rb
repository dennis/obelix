require 'spec_helper'

module Obelix
  module AMI
    describe DisconnectedTransport do
      it_behaves_like "a transport"

      let(:hostname) { double }
      let(:username) { double }
      let(:password) { double }

      context "#connect" do
        it { expect{ subject.connect(hostname, username, password) }.to raise_error(RuntimeError) }
      end

      context "#write" do
        it { expect{ subject.write "stuff" }.to raise_error(RuntimeError) }
      end

      context "#read" do
        it { expect{ subject.read }.to raise_error(RuntimeError) }
      end
    end
  end
end
