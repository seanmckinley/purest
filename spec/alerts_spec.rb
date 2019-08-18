# frozen_string_literal: true

require 'spec_helper'

describe Purest::Alerts do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::Alerts).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'when getting email recipients that receive alerts' do
      it 'gets to the correct URL' do
        get_helper('/alert')
        alerts = Purest::Alerts.get
      end
    end
    context 'when getting information about a specific email recipient' do
      it 'gets to the correct URL' do
        get_helper('/alert/paxton.fettle@atc.com')
        alerts = Purest::Alerts.get(name: 'paxton.fettle@atc.com')
      end
    end
  end
end
