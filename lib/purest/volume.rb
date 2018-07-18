# frozen_string_literal: true

module Purest
  class Volume < Purest::Rest
    @access_methods = %i[get create update delete]

    GET_PARAMS = [:action, :block_size, :connect, :historical, :length, :names,
                  :pending, :pending_only, :pgrouplist, :private, :protect,
                  :shared, :snap, :space]

    # Get a list of volumes, GET
    # @param options [Hash] options to pass
    def get(options = nil)
      @options = options
      create_session unless authenticated?

      # Build up a url from parts, allowing for dynamic http calls
      # by simply passing in params accepted by Pure's API
      raw_resp = @conn.get do |req|
        url = ["/api/#{Purest.configuration.api_version}/volume"]

        url.map!{|u| u + "/#{@options[:name]}"} if !@options.nil? && @options[:name]

        # Map /diff, /hgroup, or /host depending on option passed
        [:show_diff, :show_hgroup, :show_host].each do |path|
          new_path = path.to_s.gsub('show_', '')
          url.map!{|u| u + "/#{new_path}"} if !@options.nil? && @options[path]
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

    # Create a volume, POST
    # @param options [Hash] options to pass
    def create(options = nil)
      @options = options

      raw_resp = @conn.post do |req|
        url = "/api/#{Purest.configuration.api_version}/volume"
        url += "/#{@options[:name]}" if @options[:name]
        url += "/pgroup/#{@options[:pgroup]}" if @options[:pgroup]
        req.body = @options.to_json

        req.url url
      end

      JSON.parse(raw_resp.body, :symbolize_names => true)
    end

    # Update a volume, PUT
    # @param options [Hash] options to pass
    def update(options = nil)
      @options = options

      raw_resp = @conn.put do |req|
        # Here we construct the url first, because the options hash
        # may have to be manipulated below
        req.url "/api/#{Purest.configuration.api_version}/volume/#{@options[:name]}"

        # Repurpose @options[:name] so that it is now set to the new_name
        # allowing us to rename a volume.
        @options[:name] = @options.delete(:new_name) if @options[:new_name]

        # Remove name from @options which is sent in the body,
        # if size is passed in, because those two cannot be sent together.
        @options.delete(:name) if @options[:size]

        req.body = @options.to_json
      end

      JSON.parse(raw_resp.body, :symbolize_names => true)
    end

    # Delete a volume, DELETE
    # @param options [Hash] options to pass
    def delete(options = nil)
      @options = options

      raw_resp = @conn.delete do |req|
        url = "/api/#{Purest.configuration.api_version}/volume/#{@options[:name]}"
        url += "/pgroup/#{@options[:pgroup]}" if @options[:pgroup]

        req.url url
      end

      if @options[:eradicate]
        raw_resp = @conn.delete do |req|
          url = ["/api/#{Purest.configuration.api_version}/volume/#{@options[:name]}"]
          req.body = @options.to_json

          req.url concat_url url
        end
      end

      JSON.parse(raw_resp.body, :symbolize_names => true)
    end

    private

    # Dynamic method generation, e.g. use_connect, use_eradicate, etc
    GET_PARAMS.each do |param|
      define_method :"use_#{param}" do |options|
        options ? use_named_parameter(param, options[param]) : []
      end
    end
  end
end
