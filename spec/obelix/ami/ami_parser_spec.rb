require 'spec_helper'

module Obelix
  module AMI
    describe AmiParser do
      subject { AmiParser.new }

      context "#assemble" do
        let(:h_object) { double(map: ["Key1: Value1", "Key2: Value2"]) }
        let(:packet) do
          packet = double
          allow(packet).to receive(:to_h).and_return(h_object)
          packet
        end

        let(:expected_string) { "Key1: Value1\r\nKey2: Value2\r\n\r\n" }

        it { expect(subject.assemble(packet)).to eql(expected_string) }
      end

      context "#assemble format of each key/value pair" do
        let(:packet) do
          packet = Packet.new
          packet["Key"] = "Value"
          packet
        end

        it { expect(subject.assemble(packet)).to eql("key: Value\r\n\r\n") }
      end

      context "#parse" do
        let(:packet1) { double(Packet, :[]= => nil, :[] => nil) }
        let(:packet2) { double(Packet, :[]= => nil, :[] => nil) }

        let(:input) { '' }

        before { allow(Packet).to receive(:new).and_return(packet1, packet2) }

        context "data delivered at once" do
          after do
            subject.parse(input)
          end

          context "one incomplete message" do
            let(:input) { "Key1: Value1\r\nKey2: Value2\r\n" }

            it {expect(packet1).to receive(:[]=).at_most(0).times }
          end

          context "one single full message" do
            let(:input) { "Key1: Value1\r\nKey2: Value2\r\n\r\n" }

            it {expect(packet1).to receive(:[]=).with("Key1", "Value1") }
            it {expect(packet1).to receive(:[]=).with("Key2", "Value2") }
          end

          context "two full messages" do
            let(:input) { "Key1: Value1\r\n\r\nKey2: Value2\r\n\r\n" }

            it {expect(packet1).to receive(:[]=).with("Key1", "Value1") }
            it {expect(packet2).to receive(:[]=).with("Key2", "Value2") }
          end

          context "one full and an incomplete message" do
            let(:input) { "Key1: Value1\r\n\r\nKey2: Value2\r\n" }

            it {expect(packet1).to receive(:[]=).with("Key1", "Value1") }
          end
        end

        context "data delivered fragmented" do
          after do
            subject.parse(input1)
            subject.parse(input2)
          end

          context "one incomplete message" do
            let(:input1) { "Key1: Val" }
            let(:input2) { "ue1\r\nKey2: Value2\r\n" }

            it {expect(packet1).to receive(:[]=).at_most(0).times }
          end

          context "one single full message" do
            let(:input1) { "Key1: Val" }
            let(:input2) { "ue1\r\nKey2: Value2\r\n\r\n" }

            it {expect(packet1).to receive(:[]=).with("Key1", "Value1") }
            it {expect(packet1).to receive(:[]=).with("Key2", "Value2") }
          end

          context "two full messages" do
            let(:input1) { "Key1: Value1\r\n\r\nKey" }
            let(:input2) { "2: Value2\r\n\r\n" }

            it {expect(packet1).to receive(:[]=).with("Key1", "Value1") }
            it {expect(packet2).to receive(:[]=).with("Key2", "Value2") }
          end

          context "one full and an incomplete message" do
            let(:input1) { "Key1: Value1\r" }
            let(:input2) { "\n\r\nKey2: Value2\r\n" }

            it {expect(packet1).to receive(:[]=).with("Key1", "Value1") }
          end
        end

        context "non key/value responses" do
          let(:packet1) { double(Packet, :[]= => nil, :[] => nil, :add_unparsed_line => nil ) }

          after { subject.parse(input) }

          context "if no : in key/value line" do
            let(:input) { "Key1: Value1\r\nKey2 Value2\r\nKey3: Value3\r\n\r\n" }

            it do
              expect(packet1).to receive(:[]=).with("Key1", "Value1").ordered
              expect(packet1).to receive(:add_unparsed_line).with("Key2 Value2\r\n").ordered
              expect(packet1).to receive(:add_unparsed_line).with("Key3: Value3\r\n").ordered
            end
          end

          context "if \n key/value line" do
            let(:input) { "Key1: Value1\r\nKey2\nValue2\r\n\r\n" }

            it { expect(packet1).to receive(:[]=).with("Key1", "Value1") }
            it { expect(packet1).to receive(:add_unparsed_line).with("Key2\nValue2\r\n") }
          end
        end

        context "it should return correct packet type" do
          let(:input) { "Key1: Value1\r\nKey2: Value2\r\n\r\n" }

          context "event" do
            before { allow(packet1).to receive(:[]).with("Event").and_return("Yup") }

            it { expect(subject.parse(input)).to be_instance_of Array }
            it { expect(subject.parse(input).length).to eql(1) }
            it { expect(subject.parse(input)[0]).to be_instance_of Event }
          end

          context "response" do
            it { expect(subject.parse(input)).to be_instance_of Array }
            it { expect(subject.parse(input).length).to eql(1) }
            it { expect(subject.parse(input)[0]).to be_instance_of Response }
          end
        end
      end
    end
  end
end
