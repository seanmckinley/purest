# frozen_string_literal: true

require 'spec_helper'

describe Purest::SNMP do
  it { expect(described_class).to be < Purest::Rest}

  before do
    allow_any_instance_of(Purest::SNMP).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'No options passed' do
      it 'gets a list of designated SNMP managers' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/snmp").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        snmp_list = Purest::SNMP.get
      end
    end
    context 'when getting a specified snmp manager' do
      it 'gets a specified SNMP manager' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/snmp/localhost").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        snmp_list = Purest::SNMP.get(:name => 'localhost')
      end
    end
  end
  describe '#post' do
    context 'when creating an snmp manager object using a DNS name' do
      it 'posts to the correct url with at least a host value passed' do
        stub_request(:post, "#{Purest.configuration.url}/api/1.11/snmp/snmp-manager1").
          with(
            body: "{\"name\":\"snmp-manager1\",\"host\":\"snmphost1.example.com\"}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        snmp_manager = Purest::SNMP.create(:name => 'snmp-manager1', :host => 'snmphost1.example.com' )
      end
    end
    context 'when creating an snmp manager object using an IPV4 address and specifying a port' do
      it 'posts to the correct url with an ipv4 host attribute' do
        stub_request(:post, "#{Purest.configuration.url}/api/1.11/snmp/snmp-manager1").
          with(
            body: "{\"name\":\"snmp-manager1\",\"host\":\"111.11.11.111:222\"}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        snmp_manager = Purest::SNMP.create(:name => 'snmp-manager1', :host => '111.11.11.111:222' )
      end
    end
    context 'when creating an snmp manager object using an IPV6 address' do
      it 'posts to the correct url with an ipv6 host attribute' do
        stub_request(:post, "#{Purest.configuration.url}/api/1.11/snmp/snmp-manager1").
          with(
            body: "{\"name\":\"snmp-manager1\",\"host\":\"[FE80::0202:B3FF:FE1E:8329]:222\"}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        snmp_manager = Purest::SNMP.create(:name => 'snmp-manager1', :host => '[FE80::0202:B3FF:FE1E:8329]:222' )
      end
    end
  end
  describe '#put' do
    context 'when renaming an snmp manager' do
      it 'puts to the correct url with the correct parameters' do
        stub_request(:put, "#{Purest.configuration.url}/api/1.11/snmp/snmp-manager").
          with(
            body: "{\"name\":\"snmp-manager-renamed\"}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
            updated_snmp = Purest::SNMP.update(:name => 'snmp-manager', :new_name => 'snmp-manager-renamed')
      end
    end
  end
  describe '#delete' do
    context 'when renaming an snmp manager' do
      it 'puts to the correct url with the correct parameters' do
        stub_request(:delete, "#{Purest.configuration.url}/api/1.11/snmp/snmp-manager").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        updated_snmp = Purest::SNMP.delete(:name => 'snmp-manager')
      end
    end
  end
end
