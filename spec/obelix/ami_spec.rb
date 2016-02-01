require 'spec_helper'

module Obelix
  describe AMI do
    let(:hostname) { 'hostname' }
    let(:transport) { double }
    let(:client) { double(:connect => nil) }

    before do
      allow(AMI::TCPTransport).to receive(:new).and_return(transport)
      allow(AMI::Client).to receive(:new).and_return(client)
    end

    context "#self.client" do
      after { subject::client(hostname) }

      it { expect(AMI::Client).to receive(:new).with(transport: transport) }
      it { expect(client).to receive(:connect).with(hostname) }
    end

    context "EOM" do
      it { expect(subject::EOM).to eql("\r\n\r\n") }
    end

    context "EOL" do
      it { expect(subject::EOL).to eql("\r\n") }
    end
  end
end

