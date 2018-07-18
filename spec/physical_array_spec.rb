# frozen_string_literal: true

require 'spec_helper'

describe Purest::PhysicalArray do
  let(:faraday) { fake }

  it { expect(described_class).to be < Purest::Rest}

  describe '#get' do
    before do
      allow_any_instance_of(Purest::PhysicalArray).to receive(:authenticated?).and_return(true)
    end
    context 'No options passed' do
      it 'should get to the correct url' do
        stub_request(:get, "https://purehost.com/api/1.11/array").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        arrays = Purest::PhysicalArray.get
        expect(arrays).to be_an(Array) # yo dawg, I heard you like arrays
      end
    end
    context 'when listing connected arrays' do
      it 'should get to the correct url' do
        stub_request(:get, "https://purehost.com/api/1.11/array/connection").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        arrays = Purest::PhysicalArray.get(:connection => true)
        expect(arrays).to be_an(Array)
      end
    end
    context 'when listing space usage for the last hour' do
      it 'should get to the correct url' do
        stub_request(:get, "https://purehost.com/api/1.11/array?space=true&historical=1h").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        arrays = Purest::PhysicalArray.get(:space => true, :historical => '1h')
        expect(arrays).to be_an(Array)
      end
    end
  end
  describe '#post' do
    before do
      allow_any_instance_of(Purest::PhysicalArray).to receive(:authenticated?).and_return(true)
    end
    context 'when creating a connection between purehost and purehost2' do
      it 'posts to the correct url' do
        stub_request(:post, "https://purehost.com/api/1.11/array/connection").
          with(
            body: "{\"connection_key\":\"$CONNECTION_KEY\",\"management_address\":\"purehost02.com\",\"type\":[\"replication\"]}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        connected_arrays = Purest::PhysicalArray.create(:connection_key => "$CONNECTION_KEY", :management_address => "purehost02.com", :type => ['replication'])
      end
    end
  end
  describe '#put' do
    before do
      allow_any_instance_of(Purest::PhysicalArray).to receive(:authenticated?).and_return(true)
    end
    context 'when updating an arrays attributes' do
      it 'should put to the correct url' do
        stub_request(:put, "https://purehost.com/api/1.11/array").
          with(
            body: "{\"name\":\"new-name\"}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

        updated_array = Purest::PhysicalArray.update(:new_name => 'new-name')
      end
    end
    context 'when modifying bandwidth throttling attributes for a connected array' do
      it 'should put to the correct url' do
        stub_request(:put, "https://purehost.com/api/1.11/array/connection/array123").
          with(
            body: "{\"default_limit\":\"1024K\"}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

        updated_array = Purest::PhysicalArray.update(:connected_array => 'array123', :default_limit => '1024K')
      end
    end
    context 'when enabling the console lock' do
      it 'should put to the correct url with the correct json body' do
        stub_request(:put, "https://purehost.com/api/1.11/array/console_lock").
          with(
            body: "{\"enabled\":true}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

        console_locked = Purest::PhysicalArray.update(:console_lock => true)
      end
    end
    context 'when performing a phonehome action' do
      it 'should put to the correct url with the correct json body' do
        stub_request(:put, "https://purehost.com/api/1.11/array/phonehome").
          with(
            body: "{\"action\":\"send_all\",\"enabled\":true}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

        et_phone_home = Purest::PhysicalArray.update(:phonehome => true, :action => 'send_all')
      end
    end
    context 'when updating remote assist' do
      it 'should maybe, probably, definitely put to the correct url with the correct json body' do
        stub_request(:put, "https://purehost.com/api/1.11/array/remoteassist").
          with(
            body: "{\"action\":\"connect\"}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})


        robot_life_alert = Purest::PhysicalArray.update(:remote_assist => 'connect')
      end
    end
  end
  describe '#delete' do
    before do
      allow_any_instance_of(Purest::PhysicalArray).to receive(:authenticated?).and_return(true)
    end
    context 'when disconnecting the current array from a specified array' do
      it 'should delete to the correct url' do
        stub_request(:delete, "https://purehost.com/api/1.11/array/connection/purehost02").
          with(
            body: "",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

      disconnected_array = Purest::PhysicalArray.delete(:connected_array => 'purehost02')
      end
    end
  end
end
