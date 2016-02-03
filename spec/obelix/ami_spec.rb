require 'spec_helper'

module Obelix
  describe AMI do
    let(:hostname) { 'hostname' }
    let(:client) { double(:connect => nil) }
    let(:protocol) { double(AMI::Protocol) }
    let(:transport) { double(AMI::TCPTransport) }
    let(:parser) { double(AMI::AmiParser) }
    let(:actions) { double(AMI::ClientActions) }

    before do
      allow(AMI::Protocol).to receive(:new).and_return(protocol)
      allow(AMI::TCPTransport).to receive(:new).and_return(transport)
      allow(AMI::AmiParser).to receive(:new).and_return(parser)
      allow(AMI::Client).to receive(:new).and_return(client)
      allow(AMI::ClientActions).to receive(:new).and_return(actions)
    end

    context "#self.client" do
      after { subject::client(hostname) }

      it { expect(AMI::Protocol).to receive(:new).with(transport: transport, parser: parser) }
      it { expect(client).to receive(:connect).with(hostname) }
      it { expect(AMI::ClientActions).to receive(:new) }
      it { expect(AMI::Client).to receive(:new).with(protocol: protocol, actions: actions) }
    end

    context "EOM" do
      it { expect(subject::EOM).to eql("\r\n\r\n") }
    end

    context "EOL" do
      it { expect(subject::EOL).to eql("\r\n") }
    end
  end
end

