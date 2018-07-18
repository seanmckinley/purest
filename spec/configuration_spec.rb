# frozen_string_literal: true

require 'spec_helper'

describe Purest do
  describe 'configuration' do
    before(:each) do
      expect(Purest.configuration).to_not be_nil
      expect(Purest.configuration).to be_a Purest::Configuration
      Purest.configuration = Purest::Configuration.new
    end

    context 'Default' do
      let(:config) { Purest.configuration }

      it 'Returns a Purest::Configuration' do
        expect(config).to be_a Purest::Configuration
      end

      it 'Requires a URL be passed in' do
        expect(config.url).to be_nil
      end
    end

    context 'Custom configuration' do
      it 'Allows for custom configuration' do
        Purest.configure do |c|
          c.url = 'http://thevault.com'
          c.username = 'paxton.fettle'
          c.password = 'alma1wade'
          c.options = { ssl: { verify: true } }
        end

        expect(Purest.configuration.url).to eq('http://thevault.com')
        expect(Purest.configuration.username).to eq('paxton.fettle')
        expect(Purest.configuration.password).to eq('alma1wade')
        expect(Purest.configuration.options).to eq(ssl: { verify: true })
      end
    end
  end
end
