# frozen_string_literal: true

module Purest
  class PhysicalArray < Purest::Rest
    @access_methods = %i[get create update delete]

    GET_PARAMS = [:action, :banner, :connection_key, :controllers, :historical,
      :idle_timeout, :ntpserver, :phonehome, :proxy, :relayhost, :scsi_timeout,
      :senderdomain, :space, :syslogserver, :throttle]

    # Get a list of hosts, GET
    # @param options [Hash] options to pass
    def get(options = nil)
      @options = options
      create_session unless authenticated?

      raw_resp = @conn.get do |req|
        url = ["/api/#{Purest.configuration.api_version}/array"]

        # Map /connection, /console_lock, /phonehome, /remoteassist
        # depending on what was passed in
        [:connection, :console_lock, :phonehome, :remoteassist].each do |path|
          url.map!{|u| u + "/#{path.to_s}"} if !@options.nil? && @options[path]
        end

        # Generate array, consisting of url parts, to be built
        # by concat_url method below
        GET_PARAMS.each do |param|
          url += self.send(:"use_#{param}",@options)
        end

        # Build url from array of parts, send request
        req.url concat_url url
      end

      JSON.parse(raw_resp.body, :symbolize_names => true)
    end

    # Create a connection between two arrays
    # @param options [Hash] options to pass
    def create(options = nil)
      @options = options

      raw_resp = @conn.post do |req|
        req.url "/api/#{Purest.configuration.api_version}/array/connection"
        req.body = @options.to_json
      end

      JSON.parse(raw_resp.body, :symbolize_names => true)
    end

    # Update attributes on an array, PUT
    # @param options [Hash] options to pass in
    def update(options = nil)
      @options = options

      raw_resp = @conn.put do |req|
        url = ["/api/#{Purest.configuration.api_version}/array"]

        if !@options.nil? && @options[:connected_array]
          url.map!{|u| u + "/connection/#{@options[:connected_array]}"}
        end

        # Small conditional to ease remote assistance connecting/disconnecting
        if !@options.nil? && @options[:remote_assist]
          url.map!{|u| u + "/remoteassist"}
          @options[:action] = @options.delete(:remote_assist)
        end

        # Small loop to ease console locking and home phoning
        [:console_lock, :phonehome].each do |path|
          if !@options.nil? && @options[path]
            url.map!{|u| u + "/#{path.to_s}"}
            @options[:enabled] = @options.delete(path)
          end
        end

        # Keeping things consistent
        @options[:name] = @options.delete(:new_name) if @options[:new_name]

        # Don't send this as part of the JSON body if it's present
        # in the options hash, as it's not a valid param
        @options.delete(:connected_array)
        req.body = @options.to_json

        req.url concat_url url
      end

      JSON.parse(raw_resp.body, :symbolize_names => true)
    end

    # Disconnect one array from another
    # @param options [Hash] options to pass in
    def delete(options = nil)
      @options = options

      raw_resp = @conn.delete do |req|
        req.url "/api/#{Purest.configuration.api_version}/array/connection/#{@options[:connected_array]}"
      end
    end

    private

    GET_PARAMS.each do |attribute|
      define_method :"use_#{attribute}" do |options|
        options ? use_named_parameter(attribute, options[attribute]) : []
      end
    end
  end
end
