# frozen_string_literal: true

require 'spec_helper'

describe Purest::Drive do
  let(:faraday) { fake }

  it { expect(described_class).to be < Purest::Rest}

  before do
    allow_any_instance_of(Purest::Drive).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'when getting attributes about a flash module' do
      it 'gets to the correct URL' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/drive/SH0.BAY0").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        drives = Purest::Drive.get(:name => 'SH0.BAY0')
      end
    end
  end
end
