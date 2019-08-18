# frozen_string_literal: true

require 'spec_helper'

describe Purest::Volume do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::Volume).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'No options passed' do
      it 'gets a list of volumes' do
        get_helper('/volume')
        volumes = Purest::Volume.get
      end
    end

    context 'Getting all snapshots' do
      it 'gets a list of snapshots' do
        get_helper('/volume?snap=true')
        volumes = Purest::Volume.get(snap: true)
        expect(volumes).to be_an(Array)
      end
    end

    context 'getting a diff with block_size ON and length ON' do
      it 'should return an empty array' do
        get_helper('/volume/v1.snap/diff?block_size=512&length=2G')
        diff = Purest::Volume.get(show_diff: true, block_size: 512, name: 'v1.snap', length: '2G')
        expect(diff).to eq([])
      end
    end
  end
  describe '#post' do
    context 'creating a single volume' do
      it 'posts with a name and size' do
        post_helper(path: '/volume/new_vol', body: '{"name":"new_vol","size":"15G"}')
        volume = Purest::Volume.create(name: 'new_vol', size: '15G')
      end
    end
    context 'creating multiple snapshots' do
      it 'posts with two sources' do
        post_helper(path: '/volume', body: '{"snap":true,"source":["v1, v2"]}')
        snapshot = Purest::Volume.create(snap: true, source: ['v1, v2'])
        expect(snapshot).to be_an(Array)
      end
    end
  end

  describe '#put' do
    context 'when updating a volume name' do
      it 'puts to the correct URL' do
        put_helper(path: '/volume/v1', body: '{"name":"v1-renamed"}')
        renamed_volume = Purest::Volume.update(name: 'v1', new_name: 'v1-renamed')
      end
    end
  end

  describe '#delete' do
    before do
      delete_helper(path: '/volume/v1')
    end

    context 'when deleting a volume' do
      it 'deletes to the correct URL' do
        deleted_volume = Purest::Volume.delete(name: 'v1')
      end
    end

    context 'when eradicating a volume' do
      it 'sends the correct http body' do
        delete_helper(path: '/volume/v1', body: '{"name":"v1","eradicate":true}')
        deleted_volume = Purest::Volume.delete(name: 'v1', eradicate: true)
      end
    end
  end
end
