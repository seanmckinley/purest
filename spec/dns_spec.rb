# frozen_string_literal: true

require 'spec_helper'

describe Purest::DNS do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::DNS).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'without any options' do
      it 'gets a list of array dns attributes' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/dns")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        dns = Purest::DNS.get
      end
    end
  end
end
