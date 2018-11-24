# frozen_string_literal: true

require 'spec_helper'

describe Purest::Cert, integration: true do
  describe '#post' do
    before(:each) do
      WebMock.allow_net_connect!
      Purest.configuration.url     = INTEGRATION['url']
      Purest.configuration.api_key = INTEGRATION['api_key']
    end
    context 'when creating a cert' do
      API_VERSIONS.each do |version|
        it "actually creates a cert on api version #{version}" do
          Purest.configuration.api_version = version
          cert = Purest::Cert.create(name: 'integration-tester-cert', self_signed: true, state: 'WY')
          fetched_cert = Purest::Cert.get(name: 'integration-tester-cert')

          expect(fetched_cert[:state]).to eq('WY')
          Purest::Cert.delete(name: 'integration-tester-cert')
        end
      end
    end
    context 'when deleting a cert' do
      API_VERSIONS.each do |version|
        it "creates and deletes a cert on api version #{version}" do
          Purest.configuration.api_version = version
          cert = Purest::Cert.create(name: 'integration-tester-cert', self_signed: true, state: 'WY')
          Purest::Cert.delete(name: 'integration-tester-cert')

          non_existent_cert = Purest::Cert.get(name: 'integration-tester-cert')
          expect(non_existent_cert.first[:msg]).to eq('Certificate does not exist')
        end
      end
    end
  end
end
