# frozen_string_literal: true

require 'spec_helper'

describe Purest::HostGroup do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::HostGroup).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'No options passed' do
      it 'should get back a list of host groups on an array' do
        get_helper('/hgroup')
        host_groups = Purest::HostGroup.get
        expect(host_groups).to be_an(Array)
      end
    end
    context 'when listing information about a single hostgroup' do
      it 'should get to the correct url' do
        get_helper('/hgroup/hgroup123')
        host_group = Purest::HostGroup.get(name: 'hgroup123')
        expect(host_group).to be_an(Array)
      end
    end
    context 'when listing volumes associated with an individual host group' do
      it 'should get to the correct url' do
        get_helper('/hgroup/hgroup123/volume')
        host_group = Purest::HostGroup.get(name: 'hgroup123', show_volume: true)
        expect(host_group).to be_an(Array)
      end
    end
  end
  describe '#post' do
    context 'when creating a host group' do
      it 'should post to the correct url' do
        post_helper(path: '/hgroup/hgroup123')
        host_group = Purest::HostGroup.create(name: 'hgroup123')
        expect(host_group).to be_an(Array)
      end
    end
    context 'when connecting a volume to a host group, and specifying a LUN' do
      it 'should post to the correct url' do
        post_helper(path: '/hgroup/hgroup123/volume/volume123', body: '{"lun":13}')
        host_group = Purest::HostGroup.create(name: 'hgroup123', volume: 'volume123', lun: 13)
        expect(host_group).to be_an(Array)
      end
    end
    context 'when connecting a host group to a protection group' do
      it 'should post to the correct url' do
        post_helper(path: '/hgroup/hgroup123/pgroup/pgroup123')
        host_group = Purest::HostGroup.create(name: 'hgroup123', protection_group: 'pgroup123')
        expect(host_group).to be_an(Array)
      end
    end
  end
  describe '#put' do
    context 'when updating a host group by renaming it' do
      it 'should put to the correct url, with the correct params' do
        put_helper(path: '/hgroup/hgroup123', body: '{"name":"hgroup456"}')
        renamed_host = Purest::HostGroup.update(name: 'hgroup123', new_name: 'hgroup456')
      end
    end
  end
  describe '#delete' do
    context 'when deleting a host group' do
      it 'should delete to the correct url' do
        delete_helper(path: '/hgroup/hgroup123')
        deleted_host = Purest::HostGroup.delete(name: 'hgroup123')
      end
    end
  end
end
