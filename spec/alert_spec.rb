# frozen_string_literal: true

require 'spec_helper'

describe Purest::Alert do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::Alert).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'when getting email recipients that receive alerts' do
      it 'gets to the correct URL' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/alert")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        alerts = Purest::Alert.get
      end
    end
    context 'when getting information about a specific email recipient' do
      it 'gets to the correct URL' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/alert/paxton.fettle@atc.com")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        alerts = Purest::Alert.get(name: 'paxton.fettle@atc.com')
      end
    end
  end
end
