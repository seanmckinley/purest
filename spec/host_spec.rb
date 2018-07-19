# frozen_string_literal: true

require 'spec_helper'

describe Purest::Host do
  let(:faraday) { fake }

  it { expect(described_class).to be < Purest::Rest}

  describe '#get' do
    before do
      allow_any_instance_of(Purest::Host).to receive(:authenticated?).and_return(true)
    end
    context 'No options passed' do
      it 'should get back a list of hosts on an array' do
        stub_request(:get, "https://purehost.com/api/1.11/host").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        hosts = Purest::Host.get
        expect(hosts).to be_an(Array)
      end
    end
    context 'when passing action=monitor' do
      let(:json) do
        JSON.generate( [ { "input_per_sec": 0, "name": "h1" } ])
      end
      it 'should return monitoring details' do
        stub_request(:get, "https://purehost.com/api/1.11/host?action=monitor").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: json, headers: {})
        hosts = Purest::Host.get(:action => 'monitor')

        expect(hosts).to be_an(Array)
      end
    end
    context 'when listing information about space consumpion for a host' do
      let(:json) do
        JSON.generate({ "data_reduction": 1.0, "name": "h1", "snapshots": 0 })
      end

      it 'should get with the correct url' do
        stub_request(:get, "https://purehost.com/api/1.11/host/h1?space=true").
        with(
          headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Faraday v0.15.2'
          }).
        to_return(status: 200, body: json, headers: {})

        host_snapshots = Purest::Host.get(:name => 'h1', :space => true)

        expect(host_snapshots).to be_a(Hash)
        expect(host_snapshots[:snapshots]).to eq(0)
      end
    end
    context 'when listing volumes associated with a specified host' do
      it 'should get with the correct url' do
        stub_request(:get, "https://purehost.com/api/1.11/host/h1/volume").
        with(
          headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Faraday v0.15.2'
          }).
          to_return(status: 200, body: JSON.generate([]), headers: {})

        host_snapshots = Purest::Host.get(:name => 'h1', :show_volume => true)

        expect(host_snapshots).to be_an(Array)
      end
    end
  end
  end

  describe '#post' do
    before do
      allow_any_instance_of(Purest::Host).to receive(:authenticated?).and_return(true)
    end
    context 'when creating a host' do
      context 'with no params' do
        it 'posts to the correct url' do
          stub_request(:post, "https://purehost.com/api/1.11/host/new_host").
          with(
            headers: {
     	      'Accept'=>'*/*',
     	      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
     	      'Content-Type'=>'application/json',
     	      'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 200, body: JSON.generate([]), headers: {})
          new_host = Purest::Host.create(:name => 'new_host')
        end
      context 'with an iqnlist' do
        it 'posts to the correct url, with the correct params' do
          stub_request(:post, "https://purehost.com/api/1.11/host/new_host").
          with(
            body: "{\"name\":\"new_host\",\"iqnlist\":[\"1\"]}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'Content-Type'=>'application/json',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 200, body: JSON.generate([]), headers: {})
          new_host = Purest::Host.create(:name => 'new_host', :iqnlist => ['1'])
        end
      end
    end
    context 'when adding a host to a protection group' do
      it 'posts to the correct url' do
        stub_request(:post, "https://purehost.com/api/1.11/host/host123/pgroup/pgroup123").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 200, body: JSON.generate([]), headers: {})
        new_pgroup = Purest::Host.create(:name => 'host123', :protection_group => 'pgroup123')
      end
    end
    context 'when connecting a volume to a host' do
      it 'posts to the correct url' do
        stub_request(:post, "https://purehost.com/api/1.11/host/host123/volume/volume1").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 200, body: JSON.generate([]), headers: {})
        new_pgroup = Purest::Host.create(:name => 'host123', :volume => 'volume1')
      end
    end
  end

  describe '#put' do
    before do
      allow_any_instance_of(Purest::Host).to receive(:authenticated?).and_return(true)
    end
    context 'when updating a host' do
      context  'by renaming it' do
        it 'should put to the correct url, with the correct params' do
          stub_request(:put, "https://purehost.com/api/1.11/host/host123").
            with(
              body: "{\"name\":\"host456\"}",
              headers: {
       	      'Accept'=>'*/*',
       	      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	      'User-Agent'=>'Faraday v0.15.2'
              }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

            renamed_host = Purest::Host.update(:name => 'host123', :new_name => 'host456')
        end
      end
    end
  end
  describe '#delete' do
    before do
      allow_any_instance_of(Purest::Host).to receive(:authenticated?).and_return(true)
    end
    context 'when deleting a host' do
      it 'should delete to the correct url' do
        stub_request(:delete, "https://purehost.com/api/1.11/host/host123").
          with(
            headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 200, body: JSON.generate([]), headers: {})

        deleted_host = Purest::Host.delete(:name => 'host123')
      end
    end
    context 'when removing a host from a protection group' do
      it 'should delete to the correct url' do
        stub_request(:delete, "https://purehost.com/api/1.11/host/host123/pgroup/pgroup123").
          with(
            headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 200, body: JSON.generate([]), headers: {})

        removed_pgroup = Purest::Host.delete(:name => 'host123', :protection_group => 'pgroup123')
      end
    end
    context 'when breaking the connection between a host and volume' do
      it 'should delete to the correct url' do
        stub_request(:delete, "https://purehost.com/api/1.11/host/host123/volume/volume123").
          with(
            headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 200, body: JSON.generate([]), headers: {})

        removed_pgroup = Purest::Host.delete(:name => 'host123', :volume => 'volume123')
      end
    end
  end
end
