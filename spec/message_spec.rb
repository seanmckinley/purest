# frozen_string_literal: true

require 'spec_helper'

describe Purest::Message do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::Message).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'when listing audit records' do
      it 'gets to the correct URL' do
        stub_request(:get, "#{Purest.configuration.url}/api/1.11/message?audit=true")
          .with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        audit_messages = Purest::Message.get(audit: true)
      end
    end
  end
  describe '#put' do
    context 'when flagging a message' do
      it 'puts to the correct URL' do
        stub_request(:put, "#{Purest.configuration.url}/api/1.11/message/2")
          .with(
            body: '{"flagged":true}',
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Faraday v0.15.2'
            }
          )
          .to_return(status: 200, body: JSON.generate([]), headers: {})
        flagged_message = Purest::Message.update(id: 2, flagged: true)
      end
    end
  end
end
