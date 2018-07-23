# frozen_string_literal: true

require 'spec_helper'

describe Purest::Cert do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::Cert).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'when listing certificate attributes' do
      it 'gets to the correct url' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/cert")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        cert = Purest::Cert.get
      end
    end
    context 'when exporting the current certificate' do
      it 'gets to the correct url' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/cert?certificate=true")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        cert = Purest::Cert.get(certificate: true)
      end
    end
    context 'when generating a CSR' do
      it 'gets to the correct url' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/cert/certificate_signing_request?common_name=host.example.com")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        cert = Purest::Cert.get(csr: true, common_name: 'host.example.com')
      end
    end
  end
  describe '#put' do
    context 'when creating a self signed certificate' do
      it 'puts to the correct URL with some cool params' do
        stub_request(:put, "#{Purest.configuration.url}/api/1.11/cert")
          .with(
            body: '{"self_signed":true,"common_name":"host.example.com","state":"FL"}',
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        cert = Purest::Cert.update(self_signed: true, common_name: 'host.example.com', state: 'FL')
      end
    end
  end
end
