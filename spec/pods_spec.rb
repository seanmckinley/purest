# frozen_string_literal: true

require 'spec_helper'

describe Purest::Pod do
  before do
    allow_any_instance_of(Purest::Pod).to receive(:authenticated?).and_return(true)
  end

  it { expect(described_class).to be < Purest::Rest }

  describe '#get' do
    context 'with no options' do
      it 'gets a list of array pods' do
        get_helper("/pod")
        pods = Purest::Pod.get
      end
    end
    context 'when a name parameter is supplied' do
      it 'gets a list of array pods' do
        get_helper("/pod/test_pod")
        pods = Purest::Pod.get(name: 'test_pod')
      end
    end
  end

  describe '#post' do
    context 'with a source specified' do
      it 'posts with a source' do
        post_helper(path: '/pod/test_pod', body: '{"name":"test_pod","source":"pre_pod_pod"}')
        pod = Purest::Pod.create(name: 'test_pod', source: 'pre_pod_pod')
      end
    end
    context 'when stretching a pod to a peer array' do
      it 'posts with a peer array' do
        post_helper(path: '/pod/test_pod/array/test_array', body: '{"name":"test_pod","array":"test_array"}')
        stretchy_pod = Purest::Pod.create(name: 'test_pod', array: 'test_array')
      end
    end
  end

  describe '#put' do
    context 'when recovering' do
      it 'puts a recover action' do
        put_helper(path: '/pod/test_pod', body: '{"name":"test_pod","action":"recover"}')
        recovered_pod = Purest::Pod.update(name: 'test_pod', action: 'recover')
      end
    end
  end

  describe '#delete' do
    context 'when normally deleting a pod' do
      it 'sends a delete request' do
        delete_helper(path: '/pod/test_pod')
        deleted_pod = Purest::Pod.delete(name: 'test_pod')
      end
    end
    context 'when eradicating a pod' do
      it 'sends two delete requests' do
        delete_helper(path: '/pod/test_pod')
        delete_helper(path: '/pod/test_pod')
        deleted_pod = Purest::Pod.delete(name: 'test_pod', eradicate: true)
      end
    end
    context 'when unstretching a pod from an array' do
      it 'sends a delete request to the correct url' do
        delete_helper(path: '/pod/test_pod/array/test_array')
        unstretchy_pod = Purest::Pod.delete(name: 'test_pod', array: 'test_array')
      end
    end
  end
end
