# frozen_string_literal: true

require 'spec_helper'

describe Purest::HostGroup, :integration => true do
  describe '#post' do
    before(:each) do
      WebMock.allow_net_connect!
      Purest.configuration.url = INTEGRATION['url']
      Purest.configuration.username = INTEGRATION['username']
      Purest.configuration.password = INTEGRATION['password']
    end
    context 'when getting performance about a hostgroup' do
      API_VERSIONS.each do |version|
        Purest.configuration.api_version = version
        it "actually gets hostgroup information on api version #{version}" do
          host_group = Purest::HostGroup.create(:name => 'integration-tester-hgroup')
          host_group_fetched = Purest::HostGroup.get(:name => 'integration-tester-hgroup', :action => 'monitor')

          expect(host_group_fetched[:name]).to eq('integration-tester-hgroup')
          expect(host_group_fetched.keys).to include(:writes_per_sec)
          expect(host_group_fetched.keys).to include(:output_per_sec)

          Purest::HostGroup.delete(:name => 'integration-tester-hgroup')
        end
      end
    end
    context 'when creating a hostgroup' do
      API_VERSIONS.each do |version|
        Purest.configuration.api_version = version
        it "actually creates a hostgroup on api version #{version}" do
          host_group = Purest::HostGroup.create(:name => 'integration-tester-hgroup')
          host_group_fetched = Purest::HostGroup.get(:name => 'integration-tester-hgroup')
          expect(host_group_fetched[:name]).to eq('integration-tester-hgroup')

          Purest::HostGroup.delete(:name => 'integration-tester-hgroup')
        end
      end
    end
    context 'when updating a hostgroup' do
      API_VERSIONS.each do |version|
        Purest.configuration.api_version = version
        it "actually creates a hostgroup on api version #{version}" do
          Purest::HostGroup.delete(:name => 'integration-tester-hgroup')
          host_group = Purest::HostGroup.create(:name => 'integration-tester-hgroup')
          host_group_updated = Purest::HostGroup.update(:name => 'integration-tester-hgroup', :new_name => 'integration-tester-hgroup-renamed')

          # Verify the initial object no longer on remote, as it was renamed
          fetched_host_group = Purest::HostGroup.get(:name => host_group[:name]).first
          expect(fetched_host_group[:msg]).to include('does not exist')

          # Verifiy renamed object is on the remote
          fetched_updated_host_group = Purest::HostGroup.get(:name => host_group_updated[:name])
          expect(fetched_updated_host_group[:name]).to eq('integration-tester-hgroup-renamed')
          Purest::HostGroup.delete(:name => 'integration-tester-hgroup-renamed')
        end
      end
    end
  end
end
