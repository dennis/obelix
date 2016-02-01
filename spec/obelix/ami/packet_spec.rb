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

      context "unparsed_lines" do
        it { expect(subject.unparsed_lines).to be_instance_of Array }

        context "without lines" do
          it { expect(subject.unparsed_lines).to be_empty }
        end

        context "with 2 lines" do
          let(:line1) { "UNPARSED1" }
          let(:line2) { "UNPARSED2" }

          before do
            subject.add_unparsed_line(line1)
            subject.add_unparsed_line(line2)
          end

          it { expect(subject.unparsed_lines.length).to eql(2) }
          it { expect(subject.unparsed_lines[0]).to eql(line1) }
          it { expect(subject.unparsed_lines[1]).to eql(line2) }
        end
      end
    end
  end
end
