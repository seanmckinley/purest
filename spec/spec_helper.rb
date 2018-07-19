# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require 'json'
require 'purest'
require 'webmock/rspec'
require 'fakes-rspec'

API_VERSIONS = ENV['API_VERSION'] ? ENV['API_VERSION'].split : ['1.11']

INTEGRATION = Psych.load_file(File.join(__dir__,'..','.integration.yaml'))

RSpec.configure do |config|
  config.exclude_pattern = 'spec/integration/**.rb'
  config.filter_run_excluding :integration => true
  config.order = 'random'
  config.before(:each) do
    Purest.configure do |config|
      config.url = 'https://purehost.com'
      config.options = { ssl: { verify: false } }
      config.api_version = '1.11'
      config.username = 'paxton.fettle'
      config.password = 'alma1wade'
    end
  end
end
