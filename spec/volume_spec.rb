# frozen_string_literal: true

require 'spec_helper'

describe Purest::Volume do
  let(:faraday) { fake }

  it { expect(described_class).to be < Purest::Rest}

  before do
    allow_any_instance_of(Purest::Volume).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do

    context 'No options passed' do
      it 'gets a list of volumes' do
        stub_request(:get, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}/volume").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        volumes = Purest::Volume.get
      end
    end

    context 'Getting all snapshots' do
      it 'gets a list of snapshots' do
        stub_request(:get, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}/volume?snap=true").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 200, body: JSON.generate([]), headers: {})

        volumes = Purest::Volume.get(:snap => true)
        expect(volumes).to be_an(Array)
      end
    end

    context 'Getting snapshots for a specified volume' do
      it 'returns an array of hashes' do
        stub_request(:get, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}/volume/v3?snap=true").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([{}]), headers: {})

        snapshots = Purest::Volume.get(:name => 'v3', :snap => true)
        expect(snapshots).to be_an(Array)
        expect(snapshots.first).to be_a(Hash)
      end
    end

    context 'getting a diff with block_size ON and length ON' do
      let(:json) do
        JSON.generate([])
      end
      it 'should return an empty array' do
        stub_request(:get, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}/volume/v1.snap/diff?block_size=512&length=2G").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 200, body: json, headers: {})
        diff = Purest::Volume.get(:show_diff => true, :block_size => 512, :name => 'v1.snap', :length => '2G')
        expect(diff).to eq([])
      end
    end

    context 'getting shared connections for a specified volume' do
      let(:json) do
        JSON.generate([])
      end
      it 'should return an empty array' do
        stub_request(:get, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}/volume/v1/hgroup").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 200, body: json, headers: {})

        hgroup = Purest::Volume.get(:show_hgroup => true, :name => 'v1')
        expect(hgroup).to eq([])
      end
    end

    context 'getting private connections for a specified volume' do
      let(:json) do
        JSON.generate([])
      end
      it 'should return an empty array' do
        stub_request(:get, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}/volume/v1/host").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 200, body: json, headers: {})

        hgroup = Purest::Volume.get(:show_host => true, :name => 'v1')
        expect(hgroup).to eq([])
      end
    end
  end

  describe '#post' do
    context 'creating a single volume' do
      it 'posts with a name and size' do
        stub_request(:post, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}/volume/new_vol").
          with(
            body: "{\"name\":\"new_vol\",\"size\":\"15G\"}",
            headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate({}), headers: {})

        volume = Purest::Volume.create(:name => 'new_vol', :size => '15G')
        expect(volume).to be_a(Hash)
      end
    end

    context 'creating a single snapshot' do
      it 'posts with a source' do
        stub_request(:post, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}/volume").
          with(
            body: "{\"snap\":true,\"source\":[\"v1\"]}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 200, body: JSON.generate({}), headers: {})

          snapshot = Purest::Volume.create(:snap => true, :source => ['v1'])
          expect(snapshot).to be_a(Hash)
      end
    end
    context 'creating multiple snapshots' do
      it 'posts with two sources' do
        stub_request(:post, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}/volume").
          with(
            body: "{\"snap\":true,\"source\":[\"v1, v2\"]}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

          snapshot = Purest::Volume.create(:snap => true, :source => ['v1, v2'])
          expect(snapshot).to be_an(Array)
      end
    end

    context 'when adding a volume to a protection group' do
      let(:json) do
        JSON.generate(:name=>'v1', :protection_group=>'pgroup1')
      end
      it 'posts to the correct URL' do
        stub_request(:post, "#{Purest.configuration.url}/api/1.11/volume/v1/pgroup/pgroup1").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 200, body: json, headers: {})

          pgroup = Purest::Volume.create(:protection_group => 'pgroup1', :name => 'v1')
          expect(pgroup).to be_a(Hash)
      end
    end

    describe '#put' do
      context 'when updating a volume name' do
        let(:json) do
          JSON.generate(:name => 'v2')
        end
        it 'puts to the correct URL' do
          stub_request(:put, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}/volume/v1").
            with(
              body: "{\"name\":\"v2\"}",
              headers: {
       	      'Accept'=>'*/*',
       	      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	      'User-Agent'=>'Faraday v0.15.2'
              }).
            to_return(status: 200, body: json, headers: {})

            renamed_volume = Purest::Volume.update(:name => 'v1', :new_name => 'v2')
            expect(renamed_volume).to be_a(Hash)
        end
      end

      describe '#delete' do
        before do
          stub_request(:delete, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}/volume/v1").
            with(
              body: "",
              headers: {
       	      'Accept'=>'*/*',
       	      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	      'User-Agent'=>'Faraday v0.15.2'
              }).
            to_return(status: 200, body: json, headers: {})
        end
        context 'when deleting a volume' do
          let(:json) do
            JSON.generate(:name=>'v1')
          end

          it 'deletes to the correct URL' do
            deleted_volume = Purest::Volume.delete(:name => 'v1')
            expect(deleted_volume).to be_a(Hash)
          end
        end

        context 'when eradicating a volume' do
          let(:json) do
            JSON.generate(:name=>'v1')
          end
          it 'sends the correct http body' do
            stub_request(:delete, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}/volume/v1").
              with(
                body: "{\"name\":\"v1\",\"eradicate\":true}",
                headers: {
       	        'Accept'=>'*/*',
       	        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	        'User-Agent'=>'Faraday v0.15.2'
                }).
              to_return(status: 200, body: json, headers: {})

            deleted_volume = Purest::Volume.delete(:name => 'v1', :eradicate => true)
            expect(deleted_volume).to be_a(Hash)
          end
        end

        context 'when deleting a volume from a protection group' do
          let(:json) do
            JSON.generate(:name=>'v1')
          end
          it 'sends a delete to the correct url' do
            stub_request(:delete, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}/volume/v1/pgroup/pgroup1").
              with(
                body: "",
                headers: {
       	        'Accept'=>'*/*',
       	        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	        'User-Agent'=>'Faraday v0.15.2'
                }).
              to_return(status: 200, body: json, headers: {})

            deleted_pgroup = Purest::Volume.delete(:name => 'v1', :protection_group => 'pgroup1')
            expect(deleted_pgroup).to be_a(Hash)
          end
        end
      end
    end
  end
end
