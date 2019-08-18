# frozen_string_literal: true

require 'spec_helper'

describe Purest::App do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::App).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'with no options' do
      it 'gets a list of array apps' do
        get_helper('/app')
        apps = Purest::App.get
      end
    end
  end
end
