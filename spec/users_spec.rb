# frozen_string_literal: true

require 'spec_helper'

describe Purest::Users do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::Users).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'when listing information about users' do
      it 'gets to the correct URL' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/admin")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        users = Purest::Users.get
      end
    end
    context 'when listing information about a specific user' do
      it 'gets to the correct URL' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/admin/user1?publickey=true")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        users = Purest::Users.get(name: 'user1', publickey: true)
      end
    end
    context 'when listing the API token for the specified user' do
      it 'should get to the correct URL' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/admin/user1/apitoken")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        user_token = Purest::Users.get(name: 'user1', api_token: true)
      end
    end
  end
  describe '#post' do
    context 'when creating an API token for a specified user' do
      it 'posts to the correct URL, with the correct HTTP body' do
        stub_request(:post, "#{Purest.configuration.url}/api/1.11/admin/user1/apitoken")
          .with(
            body: '{}',
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})

        api_key = Purest::Users.create(name: 'user1')
      end
    end
  end
  describe '#put' do
    context 'when updating the public key for a specified user' do
      it 'should put to the correct url with the correct HTTP body' do
        stub_request(:put, "#{Purest.configuration.url}/api/1.11/admin/user1")
          .with(
            body: '{"name":"user1","publickey":"longpublickeystring"}',
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        user = Purest::Users.update(name: 'user1', publickey: 'longpublickeystring')
      end
    end
  end
  describe '#delete' do
    context 'when deleting an API token for a specified user' do
      it 'should delete to the correct URL' do
        stub_request(:delete, "#{Purest.configuration.url}/api/1.11/admin/user1/apitoken")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        user = Purest::Users.delete(name: 'user1')
      end
    end
  end
end
