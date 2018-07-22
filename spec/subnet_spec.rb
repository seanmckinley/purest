# frozen_string_literal: true

require 'spec_helper'

describe Purest::Subnet do
  let(:faraday) { fake }

  it { expect(described_class).to be < Purest::Rest}

  before do
    allow_any_instance_of(Purest::Subnet).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'without any options' do
      it 'gets a list of array subnet attributes' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/subnet").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        subnets = Purest::Subnet.get
      end
    end
    context 'when getting a specified subnet' do
      it 'gets a list of array subnet attributes' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/subnet/subnet10").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        subnets = Purest::Subnet.get(:name => 'subnet10')
      end
    end
  end
end
