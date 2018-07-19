# frozen_string_literal: true

require 'spec_helper'

describe Purest::HostGroup do

  it { expect(described_class).to be < Purest::Rest}

  describe '#get' do
    before do
      allow_any_instance_of(Purest::HostGroup).to receive(:authenticated?).and_return(true)
    end
    context 'No options passed' do
      it 'should get back a list of hosts on an array' do
        stub_request(:get, "https://purehost.com/api/1.11/hgroup").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        host_groups = Purest::HostGroup.get
        expect(host_groups).to be_an(Array)
      end
    end
    context 'when listing information about a single hostgroup' do
      it 'should get to the correct url' do
        stub_request(:get, "https://purehost.com/api/1.11/hgroup/hgroup123").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        host_group = Purest::HostGroup.get(:name => 'hgroup123')
        expect(host_group).to be_an(Array)
      end
    end
    context 'when listing volumes associated with an individual host group' do
      it 'should get to the correct url' do
        stub_request(:get, "https://purehost.com/api/1.11/hgroup/hgroup123/volume").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        host_group = Purest::HostGroup.get(:name => 'hgroup123', :show_volume => true)
        expect(host_group).to be_an(Array)
      end
    end
  end
  describe '#post' do
    before do
      allow_any_instance_of(Purest::HostGroup).to receive(:authenticated?).and_return(true)
    end
    context 'when creating a host group' do
      it 'should post to the correct url' do
        stub_request(:post, "https://purehost.com/api/1.11/hgroup/hgroup123").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        host_group = Purest::HostGroup.create(:name => 'hgroup123')
        expect(host_group).to be_an(Array)
      end
    end
    context 'when connecting a volume to a host group' do
      it 'should post to the correct url' do
        stub_request(:post, "https://purehost.com/api/1.11/hgroup/hgroup123/volume/volume123").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        host_group = Purest::HostGroup.create(:name => 'hgroup123', :volume => 'volume123')
        expect(host_group).to be_an(Array)
      end
    end
  end
  describe '#put' do
    before do
      allow_any_instance_of(Purest::HostGroup).to receive(:authenticated?).and_return(true)
    end
    context 'by renaming it' do
      it 'should put to the correct url, with the correct params' do
        stub_request(:put, "https://purehost.com/api/1.11/hgroup/hgroup123").
          with(
            body: "{\"name\":\"hgroup456\"}",
            headers: {
     	      'Accept'=>'*/*',
     	      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
     	      'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 200, body: JSON.generate([]), headers: {})

          renamed_host = Purest::HostGroup.update(:name => 'hgroup123', :new_name => 'hgroup456')
      end
    end
  end
  describe '#delete' do
    before do
      allow_any_instance_of(Purest::HostGroup).to receive(:authenticated?).and_return(true)
    end
    context 'when deleting a host group' do
      it 'should delete to the correct url' do
        stub_request(:delete, "https://purehost.com/api/1.11/hgroup/hgroup123").
          with(
            headers: {
     	      'Accept'=>'*/*',
     	      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
     	      'User-Agent'=>'Faraday v0.15.2'
            }).
          to_return(status: 200, body: JSON.generate([]), headers: {})

          renamed_host = Purest::HostGroup.delete(:name => 'hgroup123')
      end
    end
  end
end
