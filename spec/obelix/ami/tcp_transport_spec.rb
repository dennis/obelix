require 'spec_helper'

module Obelix
  module AMI
    describe TCPTransport do
      it_behaves_like 'a transport'

      let(:hostname) { "localhost:1234" }

      let(:socket) { double(readpartial: "")  }

      subject { TCPTransport.new.connect(hostname) }

      before do
        allow(TCPSocket).to receive(:open).and_return(socket)
      end

      context "#connect" do
        after { TCPTransport.new.connect(hostname) }

        it { expect(subject.connect(hostname)).to eql(subject) }

        context "hostname is localhost:1234" do
          it { expect(TCPSocket).to receive(:open).with("localhost", 1234) }
        end

        context "hosetname is localhost" do
          let(:hostname) { 'localhost'}
          it { expect(TCPSocket).to receive(:open).with("localhost", 5038) }
        end
      end

      context "#write('content')" do
        after { subject.write "content" }

        context "socket" do
          it { expect(socket).to receive(:write).with("content") }
        end
      end

      context "#read" do
        after { subject.read }

        before do
          allow(IO).to receive(:select).with([socket], nil, nil, 30).and_return(true)
          allow(IO).to receive(:select).with([socket], nil, nil, 0).and_return(false)
        end

        context "use IO::select to see status of socket" do
          it { expect(IO).to receive(:select).with([socket], nil, nil, 30) }
        end

        context "if select returns false, don't try to read" do
          before { allow(IO).to receive(:select).and_return(false) }

          it { expect(socket).to receive(:readpartial).at_most(0) }
        end

        context "if select returns false, return empty string" do
          after {}
          before { allow(IO).to receive(:select).and_return(false) }

          it { expect(subject.read).to eq("") }
        end

        context "if select returns true, read socket" do
          it { expect(socket).to receive(:readpartial).with(4096) }
        end

        context "if select returns true, true, false. read socket twice" do
          before { allow(IO).to receive(:select).with([socket], nil, nil, 0).and_return(true, false) }

          it { expect(socket).to receive(:readpartial).with(4096).twice }
        end
      end
    end
  end
end

