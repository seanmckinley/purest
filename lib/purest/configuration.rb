# frozen_string_literal: true

module Purest
  # Methods for configuring Purest
  class Configuration
    attr_accessor :api_version, :url, :username, :password, :options

    # Override defaults for configuration
    # @param api_version [String] the API version to interact with
    # @param url [String] pure's connection URL
    # @param username [String] username to authenticate with
    # @param password [String] password to authenticate with
    # @param options [Hash] extra options to configure Faraday::Connection
    def initialize(api_version = '1.11', url = nil, username = nil, password = nil, options = {})
      @api_version = api_version
      @url = url
      @username = username
      @password = password
      @options = options
    end
  end
end
