# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require 'json'
require 'purest'
require 'webmock/rspec'
require 'fakes-rspec'

if ENV['API_VERSION']
  API_VERSIONS = ENV['API_VERSION'].include?(',') ? ENV['API_VERSION'].split(',') : ENV['API_VERSION'].split
elsif ENV['ALL_VERSIONS'] == 'true'
  API_VERSIONS = ['1.1', '1.2', '1.3', '1.4', '1.5', '1.6', '1.7', '1.8', '1.9', '1.10', '1.11'].freeze
else
  API_VERSIONS = ['1.11'].freeze
end

if RSpec.configuration.filter_manager.inclusions.rules[:integration] == true
  begin
    INTEGRATION = Psych.load_file(File.join(__dir__, '..', '.integration.yaml'))
  rescue Errno::ENOENT
    raise 'When running integration tests, you need a .integration.yaml file containing credentials and a URL'
  end
end

RSpec.configure do |config|
  config.exclude_pattern = 'spec/integration/**.rb'
  config.filter_run_excluding integration: true
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
