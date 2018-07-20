# frozen_string_literal: true

require 'spec_helper'

describe Purest::ProtectionGroup do

  it { expect(described_class).to be < Purest::APIMethods}

  describe '#get' do
    before do
      allow_any_instance_of(Purest::ProtectionGroup).to receive(:authenticated?).and_return(true)
    end
    context 'No options passed' do
      it 'should get back a list of protection groups' do
        stub_request(:get, "https://purehost.com/api/1.11/pgroup").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

        protection_groups = Purest::ProtectionGroup.get
        expect(protection_groups).to be_an(Array)
      end
    end
    context 'when getting protection groups pending deletion' do
      it 'should get to the correct url with the correct params' do
        stub_request(:get, "https://purehost.com/api/1.11/pgroup?pending=true").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

        protection_groups = Purest::ProtectionGroup.get(:pending => true)
        expect(protection_groups).to be_an(Array)
      end
      it 'should get to the correct url with the correct params' do
        stub_request(:get, "https://purehost.com/api/1.11/pgroup/pg1?pending=true").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

        protection_groups = Purest::ProtectionGroup.get(:name => 'pg1', :pending => true)
        expect(protection_groups).to be_an(Array)
      end
    end
  end
  describe '#post' do
    before do
      allow_any_instance_of(Purest::ProtectionGroup).to receive(:authenticated?).and_return(true)
    end
    context 'creating a snapshot of one or more protection groups' do
      it 'should post to the correct url, with some options' do
        stub_request(:post, "https://purehost.com/api/1.11/pgroup").
          with(
            body: "{\"snap\":true,\"source\":[\"pg1\"]}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

        protection_groups = Purest::ProtectionGroup.create(:snap => true, :source => ['pg1'])
        expect(protection_groups).to be_an(Array)
      end
    end
  end
  describe '#put' do
    before do
      allow_any_instance_of(Purest::ProtectionGroup).to receive(:authenticated?).and_return(true)
    end
    context 'creating a snapshot of one or more protection groups' do
      it 'should post to the correct url, with some options' do
        stub_request(:put, "https://purehost.com/api/1.11/pgroup/pgroup1").
          with(
            body: "{\"name\":\"pgroup1-renamed\"}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

        protection_groups = Purest::ProtectionGroup.update(:name => 'pgroup1', :new_name => 'pgroup1-renamed')
      end
    end
  end
  describe '#delete' do
    before do
      allow_any_instance_of(Purest::ProtectionGroup).to receive(:authenticated?).and_return(true)
    end
    context 'eradicating a protection group' do
      it 'should delete to the correct url, with the correct http body' do
        stub_request(:delete, "https://purehost.com/api/1.11/pgroup/pgroup1").
          with(
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})
        stub_request(:delete, "https://purehost.com/api/1.11/pgroup/pgroup1").
          with(
            body: "{\"eradicate\":true}",
            headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Faraday v0.15.2'
            }).
            to_return(status: 200, body: JSON.generate([]), headers: {})

        protection_groups = Purest::ProtectionGroup.delete(:name => 'pgroup1', :eradicate => true)
      end
    end
  end
end
