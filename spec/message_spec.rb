# frozen_string_literal: true

require 'spec_helper'

describe Purest::Messages do
  it { expect(described_class).to be < Purest::Rest }

  before do
    allow_any_instance_of(Purest::Messages).to receive(:authenticated?).and_return(true)
  end
  describe '#get' do
    context 'when listing audit records' do
      it 'gets to the correct URL' do
        get_helper('/message?audit=true')
        audit_messages = Purest::Messages.get(audit: true)
      end
    end
  end
  describe '#put' do
    context 'when flagging a message' do
      it 'puts to the correct URL' do
        put_helper(path: '/message/2', body: '{"flagged":true}')
        flagged_message = Purest::Messages.update(id: 2, flagged: true)
      end
    end
  end
end
