require 'spec_helper'

module Obelix
  module AMI
    describe Response do
      it_behaves_like "a packet"

      subject { Response.new(double) }

      context "#event?" do
        it { expect(subject.event?).to be false }
      end

      context "#response?" do
        it { expect(subject.response?).to be true }
      end
    end
  end
end
