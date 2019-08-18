# frozen_string_literal: true

require 'spec_helper'

describe Purest::Hardware do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::Hardware).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'when listing a specific hardware component information' do
      it 'gets to the correct URL' do
        get_helper('/hardware/SH0.BAY0')
        audit_hardwares = Purest::Hardware.get(name: 'SH0.BAY0')
      end
    end
  end
  describe '#put' do
    context 'when turning on the LED light to identify a piece of hardware' do
      it 'puts to the correct URL with the correct HTTP body' do
        put_helper(path: '/hardware/SH0.BAY0', body: '{"name":"SH0.BAY0","identify":"on"}')
        identified_hardware = Purest::Hardware.update(name: 'SH0.BAY0', identify: 'on')
      end
    end
  end
end
