# frozen_string_literal: true

require 'spec_helper'

describe Purest::DNS do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::DNS).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'without any options' do
      it 'gets a list of array dns attributes' do
        get_helper('/dns')
        dns = Purest::DNS.get
      end
    end
  end
end
