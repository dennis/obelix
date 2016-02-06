require 'spec_helper'

RSpec.shared_examples "a command result" do
  it { expect(subject).to respond_to :success? }
  it { expect(subject).to respond_to :error? }
  it { expect(subject).to respond_to :success! }

  context "successful" do
    it { expect(success_subject.success?).to be true }
    it { expect{success_subject.success!}.not_to raise_error }
    it { expect(success_subject.success!).to eql(success_subject) }
  end

  context "erroneous" do
    it { expect(error_subject.success?).to be false }
    it { expect{error_subject.success!}.to raise_error RuntimeError }
  end
end

