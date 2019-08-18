# frozen_string_literal: true

require 'spec_helper'

describe Purest::ProtectionGroup do
  it { expect(described_class).to be < Purest::APIMethods }

  before do
    allow_any_instance_of(Purest::ProtectionGroup).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'No options passed' do
      it 'should get back a list of protection groups' do
        get_helper('/pgroup')
        protection_groups = Purest::ProtectionGroup.get
        expect(protection_groups).to be_an(Array)
      end
    end
    context 'when getting protection groups pending deletion' do
      it 'should get to the correct url with the correct params' do
        get_helper('/pgroup?pending=true')
        protection_groups = Purest::ProtectionGroup.get(pending: true)
        expect(protection_groups).to be_an(Array)
      end
      it 'should get to the correct url with the correct params' do
        get_helper('/pgroup/pg1?pending=true')
        protection_groups = Purest::ProtectionGroup.get(name: 'pg1', pending: true)
        expect(protection_groups).to be_an(Array)
      end
    end
  end
  describe '#post' do
    context 'creating a snapshot of one or more protection groups' do
      it 'should post to the correct url, with some options' do
        post_helper(path: '/pgroup', body: '{"snap":true,"source":["pg1"]}')
        protection_groups = Purest::ProtectionGroup.create(snap: true, source: ['pg1'])
        expect(protection_groups).to be_an(Array)
      end
    end
  end
  describe '#put' do
    context 'creating a snapshot of one or more protection groups' do
      it 'should post to the correct url, with some options' do
        put_helper(path: '/pgroup/pgroup1', body: '{"name":"pgroup1-renamed"}')
        protection_groups = Purest::ProtectionGroup.update(name: 'pgroup1', new_name: 'pgroup1-renamed')
      end
    end
  end
  describe '#delete' do
    context 'eradicating a protection group' do
      it 'should delete to the correct url, with the correct http body' do
        delete_helper(path: '/pgroup/pgroup1')
        delete_helper(path: '/pgroup/pgroup1', body: '{"eradicate":true}')
        protection_groups = Purest::ProtectionGroup.delete(name: 'pgroup1', eradicate: true)
      end
    end
  end
end
