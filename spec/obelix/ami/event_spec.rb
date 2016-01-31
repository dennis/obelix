require 'spec_helper'

module Obelix
  module AMI
    describe Event do
      it_behaves_like "a packet"

      subject { Event.new(double) }

      context "#event?" do
        it { expect(subject.event?).to be true }
      end

      context "#response?" do
        it { expect(subject.response?).to be false }
      end
    end
  end
end
