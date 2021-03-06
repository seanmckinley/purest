# frozen_string_literal: true

require 'spec_helper'

describe Purest::Host do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::Host).to receive(:authenticated?).and_return(true)
  end

  describe '#get' do
    context 'No options passed' do
      it 'should get back a list of hosts on an array' do
        get_helper('/host')
        hosts = Purest::Host.get
        expect(hosts).to be_an(Array)
      end
    end
    context 'when passing action=monitor' do
      it 'should return monitoring details' do
        get_helper('/host?action=monitor')
        hosts = Purest::Host.get(action: 'monitor')

        expect(hosts).to be_an(Array)
      end
    end
    context 'when listing information about space consumpion for a host' do
      it 'should get with the correct url' do
        get_helper('/host/h1?space=true', {})
        host_snapshots = Purest::Host.get(name: 'h1', space: true)

        expect(host_snapshots).to be_a(Hash)
      end
    end
    context 'when listing volumes associated with a specified host' do
      it 'should get with the correct url' do
        get_helper('/host/h1/volume')
        host_snapshots = Purest::Host.get(name: 'h1', show_volume: true)

        expect(host_snapshots).to be_an(Array)
      end
    end
  end

  describe '#put' do
    context 'when renaming a host' do
      it 'should put to the correct url, with the correct params' do
        put_helper(path: '/host/host123', body: '{"name":"host456"}')
        renamed_host = Purest::Host.update(name: 'host123', new_name: 'host456')
      end
    end
  end

  describe '#delete' do
    context 'when deleting a host' do
      it 'should delete to the correct url' do
        delete_helper(path: '/host/host123')
        deleted_host = Purest::Host.delete(name: 'host123')
      end
    end
  end

  describe '#post' do
    context 'when creating a host' do
      context 'with no params' do
        it 'posts to the correct url' do
          post_helper(path: '/host/new_host', body: '{"name":"new_host"}')
          new_host = Purest::Host.create(name: 'new_host')
        end
      end
    end
    context 'when adding a host to a protection group' do
      it 'posts to the correct url' do
        post_helper(path: '/host/host123/pgroup/pgroup123')
        new_pgroup = Purest::Host.create(name: 'host123', protection_group: 'pgroup123')
      end
    end
  end
end
