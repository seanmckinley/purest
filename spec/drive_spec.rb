# frozen_string_literal: true

require 'spec_helper'

describe Purest::Drive do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::Drive).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'when getting attributes about a flash module' do
      it 'gets to the correct URL' do
        get_helper('/drive/SH0.BAY0')
        drives = Purest::Drive.get(name: 'SH0.BAY0')
      end
    end
  end
end
