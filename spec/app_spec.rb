# frozen_string_literal: true

require 'spec_helper'

describe Purest::App do
  let(:faraday) { fake }

  it { expect(described_class).to be < Purest::Rest}

  before do
    allow_any_instance_of(Purest::App).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'WITH EVERYTHING, EVER' do
      it 'gets a list of array apps' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/app").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        volumes = Purest::App.get(:initiators => true)
      end
    end
  end
end
