# frozen_string_literal: true

module Purest
  class PhysicalArray < Purest::APIMethods
    @access_methods = %i[get create update delete]

    GET_PARAMS = %i[action banner connection_key controllers historical
                    idle_timeout ntpserver phonehome proxy relayhost scsi_timeout
                    senderdomain space syslogserver throttle].freeze

    # Get a list of hosts, GET
    # @param options [Hash] options to pass
    def get(options = nil)
      super(options, 'array', GET_PARAMS, %i[show_connection show_console_lock show_phonehome show_remoteassist])
    end

    def create(options = nil)
      super(options, 'array/connection')
    end

    # Update attributes on an array, PUT
    # @param options [Hash] options to pass in
    def update(options = nil)
      @options = options

      raw_resp = @conn.put do |req|
        url = ["/api/#{Purest.configuration.api_version}/array"]

        if !@options.nil? && @options[:connected_array]
          url.map! { |u| u + "/connection/#{@options[:connected_array]}" }
        end

        # Small conditional to ease remote assistance connecting/disconnecting
        if !@options.nil? && @options[:remote_assist]
          url.map! { |u| u + '/remoteassist' }
          @options[:action] = @options.delete(:remote_assist)
        end

        # Small loop to ease console locking and home phoning
        %i[console_lock phonehome].each do |path|
          if !@options.nil? && @options[path]
            url.map! { |u| u + "/#{path}" }
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

      JSON.parse(raw_resp.body, symbolize_names: true)
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

    GET_PARAMS.each do |param|
      define_method :"use_#{param}" do |options|
        options ? use_named_parameter(param, options[param]) : []
      end
    end
  end
end
