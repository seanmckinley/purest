# frozen_string_literal: true

require 'spec_helper'

describe Purest::Host, integration: true do
  describe '#post' do
    before(:each) do
      WebMock.allow_net_connect!
      Purest.configuration.url = INTEGRATION['url']
      Purest.configuration.username = INTEGRATION['username']
      Purest.configuration.password = INTEGRATION['password']
    end
    context 'when creating a host' do
      API_VERSIONS.each do |version|
        it "actually creates a host on api version #{version}" do
          Purest.configuration.api_version = version
          host = Purest::Host.create(name: 'integration-tester-host')
          fetched_host = Purest::Host.get(name: 'integration-tester-host')

          expect(fetched_host[:name]).to eq(host[:name])
          Purest::Host.delete(name: 'integration-tester-host')
        end
      end
    end
  end
  describe '#put' do
    before(:each) do
      WebMock.allow_net_connect!
      Purest.configuration.url = INTEGRATION['url']
      Purest.configuration.username = INTEGRATION['username']
      Purest.configuration.password = INTEGRATION['password']
    end
    context 'when updating a host' do
      API_VERSIONS.each do |version|
        it "actually renames a host on api version #{version}" do
          Purest.configuration.api_version = version
          host = Purest::Host.create(name: 'integration-tester-host')
          host_renamed = Purest::Host.update(name: 'integration-tester-host', new_name: 'integration-tester-host-renamed')
          fetched_renamed_host = Purest::Host.get(name: host_renamed[:name])

          expect(fetched_renamed_host[:name]).to eq('integration-tester-host-renamed')
          Purest::Host.delete(name: 'integration-tester-host-renamed')
        end
      end
    end
  end
end
