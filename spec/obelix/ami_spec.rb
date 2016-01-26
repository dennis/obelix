require 'spec_helper'

module Obelix
  describe AMI do
    context "#client" do
      let(:hostname) { 'hostname' }
      let(:username) { 'username' }
      let(:secret) { 'secret' }

      it "should invoke Client.new with correct parameters" do
        expect(AMI::Client).to receive(:new).with(hostname, username, secret)

        subject::client(hostname, username, secret)
      end
    end
  end
end

