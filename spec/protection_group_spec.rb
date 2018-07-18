# frozen_string_literal: true

require 'spec_helper'

describe Purest::ProtectionGroup do

  it { expect(described_class).to be < Purest::Rest}

  describe '#get' do
    before do
      allow_any_instance_of(Purest::ProtectionGroup).to receive(:authenticated?).and_return(true)
    end
    context 'No options passed' do
      it 'should get back a list of hosts on an array' do
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
      it 'should get back a list of hosts on an array' do
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
    end
  end
end
