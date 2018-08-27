# frozen_string_literal: true

require 'spec_helper'

describe Purest::Cert do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::Cert).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'on api v1.11 or lower' do
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
    context 'on api v1.12 or higher' do
      context 'when listing attributes about a specific certificate' do
        it 'gets to the correct url' do
          stub_request(:get, "#{Purest.configuration.url}/api/1.11/cert/dummy_cert")
            .with(
              headers: {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'User-Agent' => 'Faraday v0.15.2'
              }
            )
            .to_return(status: 200, body: JSON.generate([]), headers: {})
          cert = Purest::Cert.get(name: 'dummy_cert')
        end
      end
      context 'when exporting a named certificate' do
        it 'gets to the correct url' do
          stub_request(:get, "#{Purest.configuration.url}/api/1.11/cert/dummy_cert?certificate=true")
            .with(
              headers: {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'User-Agent' => 'Faraday v0.15.2'
              }
            )
            .to_return(status: 200, body: JSON.generate([]), headers: {})
          cert = Purest::Cert.get(certificate: true, name: 'dummy_cert')
        end
      end
      context 'when creating a CSR for a named certificate' do
        it 'gets to the correct url' do
          stub_request(:get, "#{Purest.configuration.url}/api/1.11/cert/certificate_signing_request/dummy_cert")
            .with(
              headers: {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'User-Agent' => 'Faraday v0.15.2'
              }
            )
            .to_return(status: 200, body: JSON.generate([]), headers: {})
          cert = Purest::Cert.get(csr: true, name: 'dummy_cert')
        end
      end
    end
  end
  describe '#post' do
    context 'when creating a new certificate by name' do
      it 'puts to the correct URL with some cool params' do
        stub_request(:post, "#{Purest.configuration.url}/api/1.11/cert/new_cert")
          .with(
            body: '{"name":"new_cert","self_signed":true,"common_name":"host.example.com","state":"FL"}',
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
          cert = Purest::Cert.create(name: 'new_cert', self_signed: true, common_name: 'host.example.com', state: 'FL')
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
  describe '#delete' do
    context 'when creating a self signed certificate' do
      it 'puts to the correct URL with some cool params' do
        stub_request(:delete, "#{Purest.configuration.url}/api/1.11/cert/new_cert")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        cert = Purest::Cert.delete(name: 'new_cert')
      end
    end
  end
end
