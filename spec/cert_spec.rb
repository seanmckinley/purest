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
          get_helper('/cert')
          cert = Purest::Cert.get
        end
      end
      context 'when exporting or getting attributes of a specified cert' do
        it 'gets to the correct url' do
          get_helper('/cert/super_cert?certificate=true')
          cert = Purest::Cert.get(name: 'super_cert', certificate: true)
        end
      end
      context 'when generating a CSR' do
        it 'gets to the correct url' do
          get_helper('/cert/certificate_signing_request/super_cert?common_name=host.example.com')
          cert = Purest::Cert.get(name: 'super_cert', csr: true, common_name: 'host.example.com')
        end
      end
    end
    context 'on api v1.12 or higher' do
      context 'when listing attributes about a specific certificate' do
        it 'gets to the correct url' do
          get_helper('/cert/dummy_cert')
          cert = Purest::Cert.get(name: 'dummy_cert')
        end
      end
      context 'when exporting a named certificate' do
        it 'gets to the correct url' do
          get_helper('/cert/dummy_cert?certificate=true')
          cert = Purest::Cert.get(certificate: true, name: 'dummy_cert')
        end
      end
      context 'when creating a CSR for a named certificate' do
        it 'gets to the correct url' do
          get_helper('/cert/certificate_signing_request/dummy_cert')
          cert = Purest::Cert.get(csr: true, name: 'dummy_cert')
        end
      end
    end
  end
  describe '#post' do
    context 'when creating a new certificate by name' do
      it 'puts to the correct URL with some cool params' do
        post_helper(
          path: '/cert/new_cert',
          body: '{"name":"new_cert","self_signed":true,"common_name":"host.example.com","state":"FL"}'
        )
        cert = Purest::Cert.create(name: 'new_cert', self_signed: true, common_name: 'host.example.com', state: 'FL')
      end
    end
  end
  describe '#put' do
    context 'when creating a self signed certificate' do
      it 'puts to the correct URL with some cool params' do
        put_helper(path: '/cert/new_self_signed_cert',
                   body: '{"name":"new_self_signed_cert","self_signed":true,"common_name":"host.example.com","state":"FL"}')

        cert = Purest::Cert.update(name: 'new_self_signed_cert', self_signed: true, common_name: 'host.example.com', state: 'FL')
      end
    end
  end
  describe '#delete' do
    context 'when creating a self signed certificate' do
      it 'puts to the correct URL with some cool params' do
        delete_helper(path: '/cert/new_cert')
        cert = Purest::Cert.delete(name: 'new_cert')
      end
    end
  end
end
