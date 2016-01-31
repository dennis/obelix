require 'spec_helper'

RSpec.shared_examples "a packet" do
  let(:packet) { double }

  subject { described_class.new(packet) }

  context "#event?" do
    it { expect(subject).to respond_to :event? }
  end

  context "#response?" do
    it { expect(subject).to respond_to :response? }
  end

  context "#[]" do
    let(:result) { 'BAR' }
    before { allow(packet).to receive(:[]).with("foo").and_return(result) }

    context "packet" do
      it { expect(packet).to receive(:[]).with("foo"); subject["foo"] }
    end
    it { expect(subject["foo"]).to eql(result) }
  end

  context "#to_h" do
    let(:result) { { a: 1 } }

    before { allow(packet).to receive(:to_h).and_return(result) }

    it { expect(subject.to_h).to eq(result) }

    context "packet" do
      it { expect(packet).to receive(:to_h); subject.to_h }
    end
  end

  context "self.from_packet" do
    subject { described_class }

    it { expect(subject.from_packet(packet)).to be_a described_class }
    it { expect(subject.from_packet(packet).packet).to eql(packet) }
  end
end
