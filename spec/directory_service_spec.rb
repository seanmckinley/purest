# frozen_string_literal: true

require 'spec_helper'

describe Purest::DirectoryService do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::DirectoryService).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'when getting the directory service CA cert' do
      it 'gets to the correct url' do
        get_helper('/directoryservice?certificate=true')
        directory_service = Purest::DirectoryService.get(certificate: true)
      end
    end
  end
  describe '#put' do
    context 'when updating directory service attributes' do
      it 'puts to the correct url, with the correct HTTP body' do
        put_helper(path: '/directoryservice', body: '{"bind_password":"superpassword"}')
        directory_service = Purest::DirectoryService.update(bind_password: 'superpassword')
      end
    end
  end
end
