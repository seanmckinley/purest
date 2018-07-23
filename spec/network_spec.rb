# frozen_string_literal: true

require 'spec_helper'

describe Purest::Network do
  let(:faraday) { fake }

  it { expect(described_class).to be < Purest::Rest}

  before do
    allow_any_instance_of(Purest::Network).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'without any options' do
      it 'gets a list of array network attributes' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/network").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        networks = Purest::Network.get
      end
    end
    context 'when getting a specific network' do
      it 'gets a list of array network attributes' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/network/alpha.eth0").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        networks = Purest::Network.get(:name => 'alpha.eth0')
      end
    end
  end
  describe '#post' do
    context 'when creating a vlan interface' do
      it 'posts to the correct url' do
        stub_request(:post, "#{Purest.configuration.url}/api/1.11/network/vif/vlan1").
          with(
            body: "{\"name\":\"vlan1\",\"subnet\":\"subnet10\"}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

        vlan = Purest::Network.create(:name => 'vlan1', :subnet => 'subnet10')
      end
    end
  end
  describe '#put' do
    context 'when updating attributes' do
      it 'posts to the correct url with the correct HTTP body' do
        stub_request(:put, "#{Purest.configuration.url}/api/1.11/network/alpha.eth0").
          with(
            body: "{\"name\":\"alpha.eth0\",\"mtu\":2000}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

        interface = Purest::Network.update(:name => 'alpha.eth0', :mtu => 2000)
      end
    end
  end
  describe '#delete' do
    context 'when updating attributes' do
      it 'posts to the correct url with the correct HTTP body' do
        stub_request(:delete, "#{Purest.configuration.url}/api/1.11/network/alpha.eth0").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

        interface = Purest::Network.delete(:name => 'alpha.eth0')
      end
    end
  end
end
