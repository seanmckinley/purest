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
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/hardware/SH0.BAY0")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        audit_hardwares = Purest::Hardware.get(name: 'SH0.BAY0')
      end
    end
  end
  describe '#put' do
    context 'when turning on the LED light to identify a piece of hardware' do
      it 'puts to the correct URL with the correct HTTP body' do
        stub_request(:put, "#{Purest.configuration.url}/api/1.11/hardware/SH0.BAY0")
          .with(
            body: '{"name":"SH0.BAY0","identify":"on"}',
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        identified_hardware = Purest::Hardware.update(name: 'SH0.BAY0', identify: 'on')
      end
    end
  end
end
