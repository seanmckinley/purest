# frozen_string_literal: true

require 'spec_helper'

describe Purest::Subnet do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::Subnet).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'without any options' do
      it 'gets a list of array subnet attributes' do
        get_helper('/subnet')
        subnets = Purest::Subnet.get
      end
    end
    context 'when getting a specified subnet' do
      it 'gets a list of array subnet attributes' do
        get_helper('/subnet/subnet10')
        subnets = Purest::Subnet.get(name: 'subnet10')
      end
    end
  end
end
