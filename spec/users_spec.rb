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
        get_helper('/admin')
        users = Purest::Users.get
      end
    end
    context 'when listing information about a specific user' do
      it 'gets to the correct URL' do
        get_helper('/admin/user1?publickey=true')
        users = Purest::Users.get(name: 'user1', publickey: true)
      end
    end
  end
  describe '#post' do
    context 'when creating an API token for a specified user' do
      it 'posts to the correct URL, with the correct HTTP body' do
        post_helper(path: '/admin/user1/apitoken')
        api_key = Purest::Users.create(name: 'user1')
      end
    end
  end
  describe '#put' do
    context 'when clearing the user permission cache enteries' do
      it 'puts to the correct URL' do
        put_helper(path: '/admin', body: '{"clear":true}')
        cleared_cache = Purest::Users.update(clear: true)
      end
    end
  end
  describe '#delete' do
    context 'when deleting an API token for a specified user' do
      it 'should delete to the correct URL' do
        delete_helper(path: '/admin/user1/apitoken')
        user = Purest::Users.delete(name: 'user1')
      end
    end
  end
end
