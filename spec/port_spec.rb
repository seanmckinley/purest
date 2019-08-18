# frozen_string_literal: true

require 'spec_helper'

describe Purest::Port do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::Port).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'when getting a list of ports with initiators set to true' do
      it 'gets a list of array ports' do
        get_helper('/port?initiators=true')
        port_info = Purest::Port.get(initiators: true)
      end
    end
  end
end
