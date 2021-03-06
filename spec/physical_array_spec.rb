# frozen_string_literal: true

require 'spec_helper'

describe Purest::PhysicalArray do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::PhysicalArray).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'No options passed' do
      it 'should get to the correct url' do
        get_helper('/array')
        arrays = Purest::PhysicalArray.get
        expect(arrays).to be_an(Array) # yo dawg, I heard you like arrays
      end
    end
    context 'when listing connected arrays' do
      it 'should get to the correct url' do
        get_helper('/array/connection')
        arrays = Purest::PhysicalArray.get(show_connection: true)
        expect(arrays).to be_an(Array)
      end
    end
    context 'when listing space usage for the last hour' do
      it 'should get to the correct url' do
        get_helper('/array?space=true&historical=1h')
        arrays = Purest::PhysicalArray.get(space: true, historical: '1h')
        expect(arrays).to be_an(Array)
      end
    end
  end
  describe '#post' do
    context 'when creating a connection between purehost and purehost2' do
      it 'posts to the correct url' do
        post_helper(
          path: '/array/connection',
          body: '{"connection_key":"$CONNECTION_KEY","management_address":"purehost02.com","type":["replication"]}'
        )
        connected_arrays = Purest::PhysicalArray.create(connection_key: '$CONNECTION_KEY', management_address: 'purehost02.com', type: ['replication'])
      end
    end
  end
  describe '#put' do
    context 'when updating an arrays attributes' do
      it 'should put to the correct url' do
        put_helper(path: '/array', body: '{"name":"new-name"}')
        updated_array = Purest::PhysicalArray.update(new_name: 'new-name')
      end
    end
    context 'when modifying bandwidth throttling attributes for a connected array' do
      it 'should put to the correct url' do
        put_helper(path: '/array/connection/array123', body: '{"default_limit":"1024K"}')
        updated_array = Purest::PhysicalArray.update(connected_array: 'array123', default_limit: '1024K')
      end
    end
    context 'when enabling the console lock' do
      it 'should put to the correct url with the correct json body' do
        put_helper(path: '/array/console_lock', body: '{"enabled":true}')
        console_locked = Purest::PhysicalArray.update(console_lock: true)
      end
    end
    context 'when performing a phonehome action' do
      it 'should put to the correct url with the correct json body' do
        put_helper(path: '/array/phonehome', body: '{"action":"send_all","enabled":true}')
        et_phone_home = Purest::PhysicalArray.update(phonehome: true, action: 'send_all')
      end
    end
    context 'when updating remote assist' do
      it 'should maybe, probably, definitely put to the correct url with the correct json body' do
        put_helper(path: '/array/remoteassist', body: '{"action":"connect"}')
        robot_life_alert = Purest::PhysicalArray.update(remote_assist: 'connect')
      end
    end
  end
  describe '#delete' do
    context 'when disconnecting the current array from a specified array' do
      it 'should delete to the correct url' do
        delete_helper(path: '/array/connection/purehost02')
        disconnected_array = Purest::PhysicalArray.delete(connected_array: 'purehost02')
      end
    end
  end
end
