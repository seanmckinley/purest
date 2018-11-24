# frozen_string_literal: true

module Purest
  # Methods for configuring Purest
  class Configuration
    attr_accessor :api_key, :api_version, :url, :username, :password, :options

    # Override defaults for configuration
    # @param api_version [String] the API version to interact with
    # @param url [String] pure's connection URL
    # @param username [String] username to authenticate with
    # @param password [String] password to authenticate with
    # @param options [Hash] extra options to configure Faraday::Connection
    def initialize(api_key = nil, api_version = nil, url = nil, username = nil, password = nil, options = {})
      load_yaml
      if load_yaml
        @api_key     = load_yaml['api_key']
        @api_version = load_yaml['api_version']
        @options     = load_yaml['options']
        @password    = load_yaml['password']
        @url         = load_yaml['url']
        @username    = load_yaml['username']
      else
        @api_key     = api_key
        @api_version = api_version
        @options     = options
        @password    = password
        @url         = url
        @username    = username
      end
    end

    def load_yaml
      begin
        Psych.load_file(ENV['HOME'] + '/.purest.yaml')
      rescue Errno::ENOENT
        false
      end
    end
  end
end
