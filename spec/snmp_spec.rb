# frozen_string_literal: true

require 'spec_helper'

describe Purest::SNMP do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::SNMP).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'No options passed' do
      it 'gets a list of designated SNMP managers' do
        get_helper('/snmp')
        snmp_list = Purest::SNMP.get
      end
    end
    context 'when getting a specified snmp manager' do
      it 'gets a specified SNMP manager' do
        get_helper('/snmp/localhost')
        snmp_list = Purest::SNMP.get(name: 'localhost')
      end
    end
  end
  describe '#post' do
    context 'when creating an snmp manager object using a DNS name' do
      it 'posts to the correct url with at least a host value passed' do
        post_helper(path: '/snmp/snmp-manager1', body: '{"name":"snmp-manager1","host":"snmphost1.example.com"}')
        snmp_manager = Purest::SNMP.create(name: 'snmp-manager1', host: 'snmphost1.example.com')
      end
    end
    context 'when creating an snmp manager object using an IPV6 address' do
      it 'posts to the correct url with an ipv6 host attribute' do
        post_helper(path: '/snmp/snmp-manager1', body: '{"name":"snmp-manager1","host":"[FE80::0202:B3FF:FE1E:8329]:222"}')
        snmp_manager = Purest::SNMP.create(name: 'snmp-manager1', host: '[FE80::0202:B3FF:FE1E:8329]:222')
      end
    end
  end
  describe '#put' do
    context 'when renaming an snmp manager' do
      it 'puts to the correct url with the correct parameters' do
        put_helper(path: '/snmp/snmp-manager', body: '{"name":"snmp-manager-renamed"}')
        updated_snmp = Purest::SNMP.update(name: 'snmp-manager', new_name: 'snmp-manager-renamed')
      end
    end
  end
  describe '#delete' do
    context 'when renaming an snmp manager' do
      it 'puts to the correct url with the correct parameters' do
        delete_helper(path: '/snmp/snmp-manager')
        updated_snmp = Purest::SNMP.delete(name: 'snmp-manager')
      end
    end
  end
end
