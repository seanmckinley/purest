# frozen_string_literal: true

module Purest
  # Base class for interacting with PURE storage REST API
  class Rest
    @access_methods = []

    # Initialize the fadaray connection, create session unless one exists
    def initialize
      establish_connection
      create_session unless authenticated?
    end

    # Check if session exists, and whether or not it's expired
    def authenticated?
      if defined? @session_expire
        Time.now.utc < @session_expire
      else
        false
      end
    end

    # Assemble a url from an array of parts.
    # @param parts [Array] the url chunks to be assembled
    # @return [String] the resultant url string
    def concat_url(parts)
      if parts.length > 1
        parts.first + '?' + parts.drop(1).join('&')
      else
        parts.first
      end
    end

    # Format url parameters into strings correctly
    # @param name [String] the name of the parameter
    # @param value [String] the value of the parameter
    # @return [Array] the resultant parameter string inside an array.
    def use_named_parameter(name, value)
      if value.is_a? Array
        ["#{name}=#{value.join(',')}"]
      else
        value ? ["#{name}=#{value}"] : []
      end
    end

    # Logout current session
    def logout
      raw_resp = @conn.delete do |req|
        req.url "/api/#{Purest.configuration.api_version}/auth/session"
      end
      remove_instance_variable(:@session_expire)
    end

    class << self
      def access_method?(meth_id)
        @access_methods.include? meth_id
      end

      def method_missing(meth_id, *args)
        if access_method?(meth_id)
          new.send(meth_id, *args)
        else

          # See https://bugs.ruby-lang.org/issues/10969
          begin
            super
          rescue NameError => err
            raise NoMethodError, err
          end
        end
      end
    end

    private

    def get_token
      raw_resp = @conn.post do |req|
        req.url "/api/#{Purest.configuration.api_version}/auth/apitoken"
        req.params = {
          "username": Purest.configuration.username.to_s,
          "password": Purest.configuration.password.to_s
        }
      end

      JSON.parse(raw_resp.body)['api_token']
    end

    def create_session
      raw_resp = @conn.post do |req|
        req.url "/api/#{Purest.configuration.api_version}/auth/session"
        req.params = {
          "api_token": get_token
        }
      end

      # Man they really tuck that away, don't they?
      @session_expire = Time.parse(raw_resp.env.response_headers['set-cookie'].split(';')[1].split(',')[1].strip).utc

      raw_resp
    end

    # Build the API Client
    def establish_connection
      @conn = build_connection
    end

    def build_connection
      Faraday.new(Purest.configuration.url, Purest.configuration.options) do |faraday|
        faraday.request :json
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
