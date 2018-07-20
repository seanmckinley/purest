# frozen_string_literal: true

require 'time'
require 'json'
require 'faraday'
require 'faraday_middleware'
require 'faraday-cookie_jar'
require 'pry'
require 'psych'

module Purest
  class << self
    attr_accessor :root_path
    attr_accessor :lib_path
    attr_accessor :configuration

    # Internal: Requires internal Faraday libraries.
    # @param *libs One or more relative String names to Faraday classes.
    # @return [nil]
    def require_libs(*libs)
      libs.each do |lib|
        require "#{lib_path}/#{lib}"
      end
    end

    alias require_lib require_libs
  end

  raise 'Purest only supports ruby >= 2.3.0' unless RUBY_VERSION.to_f >= 2.3

  self.root_path = File.expand_path __dir__
  self.lib_path = File.expand_path 'purest', __dir__

  require_libs 'rest', 'api_methods', 'configuration', 'app', 'host', 'host_group', 'physical_array', 'port', 'protection_group', 'volume'

  self.configuration ||= Purest::Configuration.new

  class << self
    # Build optional configuration by yielding a block to configure
    # @yield [Purest::Configuration]
    def configure
      self.configuration ||= Purest::Configuration.new
      yield(configuration)
    end
  end
end
