# frozen_string_literal: true

require 'spec_helper'

describe Purest::Network do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::Network).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'without any options' do
      it 'gets a list of array network attributes' do
        get_helper('/network')
        networks = Purest::Network.get
      end
    end
    context 'when getting a specific network device' do
      it 'gets a list of array network attributes' do
        get_helper('/network/alpha.eth0')
        networks = Purest::Network.get(name: 'alpha.eth0')
      end
    end
  end
  describe '#post' do
    context 'when creating a vlan interface' do
      it 'posts to the correct url' do
        post_helper(path: '/network/vif/vlan1', body: '{"name":"vlan1","subnet":"subnet10"}')
        vlan = Purest::Network.create(name: 'vlan1', subnet: 'subnet10')
      end
    end
  end
  describe '#put' do
    context 'when updating attributes' do
      it 'posts to the correct url with the correct HTTP body' do
        put_helper(path: '/network/alpha.eth0', body: '{"name":"alpha.eth0","mtu":2000}')
        interface = Purest::Network.update(name: 'alpha.eth0', mtu: 2000)
      end
    end
  end
  describe '#delete' do
    context 'when updating attributes' do
      it 'posts to the correct url with the correct HTTP body' do
        delete_helper(path: '/network/alpha.eth0')
        interface = Purest::Network.delete(name: 'alpha.eth0')
      end
    end
  end
end
