# frozen_string_literal: true

require 'spec_helper'

describe Purest::Volume, :integration => true do
  describe '#get' do
    before(:each) do
      WebMock.allow_net_connect!
      Purest.configuration.url = INTEGRATION['url']
      Purest.configuration.username = INTEGRATION['username']
      Purest.configuration.password = INTEGRATION['password']
    end
    context 'No options passed' do
      API_VERSIONS.each do |version|
        Purest.configuration.api_version = version
        it "gets a list of volumes on api version #{version}" do
          volume_list = Purest::Volume.get
          expect(volume_list).to be_an(Array)
          expect(volume_list.first).to have_key(:size)
        end
      end
    end
  end
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
          volume = Purest::Volume.create(:name => 'integration-tester', :size => '10G')
          fetched_volume = Purest::Volume.get(:name => volume[:name])

          expect(fetched_volume[:name]).to eq(volume[:name])
          expect(fetched_volume[:size]).to eq(volume[:size])

          # All of this has happened before, and all of this will happen again
          Purest::Volume.delete(:name => 'integration-tester', :eradicate => true)
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
    context 'when updating a volume' do
      API_VERSIONS.each do |version|
        it "actually changes the volume name on version #{version}" do
          Purest.configuration.api_version = version

          volume = Purest::Volume.create(:name => 'integration-tester', :size => '5g')
          newly_renamed_volume = Purest::Volume.update(:name => 'integration-tester', :new_name => 'integration-tester-renamed')

          expect(Purest::Volume.get(:name => 'integration-tester').first[:msg]).to include('does not exist')
          expect(Purest::Volume.get(:name => 'integration-tester-renamed')[:name]).to eq(newly_renamed_volume[:name])

          # Clean up
          Purest::Volume.delete(:name => 'integration-tester-renamed', :eradicate => true)
        end
      end
    end
  end
  describe '#delete' do
    before(:each) do
      WebMock.allow_net_connect!
      Purest.configuration.url = INTEGRATION['url']
      Purest.configuration.username = INTEGRATION['username']
      Purest.configuration.password = INTEGRATION['password']
    end
    context 'when deleting a volume' do
      API_VERSIONS.each do |version|
        it "actually deletes the volume name on version #{version}" do
          Purest.configuration.api_version = version

          volume = Purest::Volume.create(:name => 'integration-tester', :size => '5g')
          deleted_volume = Purest::Volume.delete(:name => 'integration-tester')

          # Expect volume to be deleted, but not eradicated
          expect(Purest::Volume.get(:name => 'integration-tester', :pending => true)[:name]).to eq(deleted_volume[:name])

          # Eradicate the pending volume
          eradicated_volume = Purest::Volume.delete(:name => 'integration-tester', :eradicate => true)

          # Expect the once pending, now eradicated volume, to not exist.
          expect(Purest::Volume.get(:name => 'integration-tester', :pending => true).first[:msg]).to include('does not exist')
        end
      end
    end
  end
end
