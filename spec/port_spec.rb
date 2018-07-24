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
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/port?initiators=true")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        port_info = Purest::Port.get(initiators: true)
      end
    end
  end
end
