require 'spec_helper'

module Obelix
  module AMI
    describe CommandResult do
      subject(:success_subject) { CommandResult.new(true) }
      subject(:error_subject) { CommandResult.new(false) }

      it_behaves_like 'a command result'
    end
  end
end
