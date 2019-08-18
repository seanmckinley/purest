# frozen_string_literal: true

require 'spec_helper'

describe Purest::Rest do
  describe '#get_token' do
    let(:faraday) { fake }
    before(:each) do

      stub_request(:post, 'https://purehost.com/api/1.11/auth/session?api_token=1234-567-89')
        .to_return(status: 200, body: "{\"username\": \"#{Purest.configuration.username}\"}", headers: {
                     'set-cookie' => "session=.super-duper-cookie; Expires=Sat, #{Time.now.utc + 30 * 60}; HttpOnly; Path=/"
                   })

      stub_request(:post, 'https://purehost.com/api/1.11/auth/apitoken?password=alma1wade&username=paxton.fettle')
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Length' => '0',
          }
        )
        .to_return(status: 200, body: '{"api_token": "sup3r-s4fe-t0k3n"}', headers: {})

      stub_request(:post, 'https://purehost.com/api/1.11/auth/session?api_token=sup3r-s4fe-t0k3n')
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Length' => '0',
          }
        )
        .to_return(status: 200, body: "{\"username\": \"#{Purest.configuration.username}\"}", headers: {
                     'set-cookie' => "session=.super-duper-cookie; Expires=Sat, #{Time.now.utc + 30 * 60}; HttpOnly; Path=/"
                   })
    end

    context 'when generating named params' do
      it 'turns an array into the correct param' do
        @obj = Purest::Rest.new
        param = @obj.use_named_parameter(:names, %w[vol1 vol2])

        expect(param).to eq(['names=vol1,vol2'])
      end
    end
    context 'when NOT authenticated' do
      it 'should return a token' do
        @obj = Purest::Rest.new
        token = @obj.send(:get_token)
        expect(token).to eq('sup3r-s4fe-t0k3n')
      end

      it 'should create a session, returns a faraday object with a cookie' do
        @obj = Purest::Rest.new
        session = @obj.send(:create_session)

        expect(session).to be_kind_of(Faraday::Response)
        expect(session.env.response_headers['set-cookie']).to include('super-duper-cookie')
      end

      it 'should rewnew its session when it has expired' do
        @obj = Purest::Rest.new
        @obj.instance_variable_set(:@session_expire, Time.now.utc - 30 * 60)
        expect(@obj.authenticated?).to eq(false)
      end
    end

    context 'when authenticated' do
      it 'should not authenticate when authenticated' do
        @obj = Purest::Rest.new
        expect(@obj.instance_variable_get(:@session_expire)).to be_kind_of(Time)
        expect(@obj).to_not receive(:create_session)
      end
    end
  end
end
