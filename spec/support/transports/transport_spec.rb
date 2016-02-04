require 'spec_helper'

RSpec.shared_examples "a transport" do
  it { expect(subject).to respond_to :connect }
  it { expect(subject).to respond_to :write }
  it { expect(subject).to respond_to :read }
  it { expect(subject).to respond_to :connected? }
end
