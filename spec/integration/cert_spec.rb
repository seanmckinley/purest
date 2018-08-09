# frozen_string_literal: true

require 'spec_helper'

describe Purest::Cert, integration: true do
  describe '#post' do
    before(:each) do
      WebMock.allow_net_connect!
      Purest.configuration.url = INTEGRATION['url']
      Purest.configuration.username = INTEGRATION['username']
      Purest.configuration.password = INTEGRATION['password']
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
  end
end
