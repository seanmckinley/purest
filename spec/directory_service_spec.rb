# frozen_string_literal: true

require 'spec_helper'

describe Purest::DirectoryService do
  let(:faraday) { fake }

  it { expect(described_class).to be < Purest::Rest}

  before do
    allow_any_instance_of(Purest::DirectoryService).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'when getting the directory service CA cert' do
      it 'gets to the correct url' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/directoryservice?certificate=true").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        directory_service = Purest::DirectoryService.get(:certificate => true)
      end
    end
  end
  describe '#put' do
    context 'when updating directory service attributes' do
      it 'puts to the correct url, with the correct HTTP body' do
        stub_request(:put, "#{Purest.configuration.url}/api/1.11/directoryservice").
          with(
            body: "{\"bind_password\":\"superpassword\"}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        directory_service = Purest::DirectoryService.update(:bind_password => 'superpassword')
      end
    end
  end
end
