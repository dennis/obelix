require 'spec_helper'

module Obelix
  module AMI
    describe Packet do
      let(:data) { { "Abc" => 1 } }
      subject { Packet.new(data) }

      context "#to_h" do
        it { expect(subject.to_h).to eql({"abc" => 1}) }
      end

      context "#[]" do
        context "direct match" do
          it { expect(subject["Abc"]).to eql(1) }
        end

        context "all lower case key" do
          it { expect(subject["abc"]).to eql(1) }
        end

        context "all upper case key" do
          it { expect(subject["ABC"]).to eql(1) }
        end
      end

      context "#[]=" do
        before { subject["ABC"] = 42 }
        it { expect(subject["abc"]).to eq(42) }
      end
    end
  end
end
