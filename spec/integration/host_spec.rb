# frozen_string_literal: true

require 'spec_helper'

describe Purest::Host, :integration => true do
  describe '#post' do
    before(:each) do
      WebMock.allow_net_connect!
      Purest.configuration.url = INTEGRATION['url']
      Purest.configuration.username = INTEGRATION['username']
      Purest.configuration.password = INTEGRATION['password']
    end
    context 'when creating a hostgroup' do
      API_VERSIONS.each do |version|
        Purest.configuration.api_version = version
        it "actually creates a host group on api version #{version}" do
          host_group = Purest::Host.create(:name => 'integration-tester-host')
          fetched_host_group = Purest::Host.get(:name => 'integration-tester-host')

          expect(fetched_host_group[:name]).to eq(host_group[:name])
          Purest::Host.delete(:name => 'integration-tester-host')
        end
      end
    end
  end
end
