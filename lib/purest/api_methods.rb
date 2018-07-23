# frozen_string_literal: true

module Purest
  class APIMethods < Purest::Rest

    def append_path(url, options)
      options.each do |path|
        new_path = path.to_s.gsub('show_', '')
        url.map!{|u| u + "/#{new_path}"} if !@options.nil? && @options[path]
      end
    end

    def get(options = nil, path = nil, params = nil, appended_paths = nil)
      @options = options
      create_session unless authenticated?

      raw_resp = @conn.get do |req|
        url = ["/api/#{Purest.configuration.api_version}/#{path}"]

        # Name is pretty universal, since most endpoints allow you to query
        # specific items, e.g. /hosts/host1 or /volume/volume1
        # where host1 and volume1 are names
        url.map!{|u| u + "/#{@options[:name]}"} if !@options.nil? && @options[:name]

        # Here we append the various paths, based on available GET endpoints
        append_path(url, appended_paths) unless appended_paths.nil?

        # Generate methods for url building based on
        # params passed in, e.g. [:pending, :action] becomes
        # use_pending and use_action
        params.each do |param|
          self.class.send(:define_method, :"use_#{param}") do |options|
            options ? use_named_parameter(param, options[param]) : []
          end
        end

        # Generate array, consisting of url parts, to be built
        # by concat_url method below
        params.each do |param|
          url += self.send(:"use_#{param}",@options)
        end

        req.url concat_url url
      end

      JSON.parse(raw_resp.body, :symbolize_names => true)
    end

    # Create a resource, POST
    # @param options [Hash] options to pass in
    # @param path [String] the endpoint to send to
    # @param appended_path [String] additional paths for some endpoints
    def create(options = nil, path = nil, appended_path = nil)
      @options = options
      create_session unless authenticated?

      raw_resp = @conn.post do |req|
        # Base URL + path
        url = ["/api/#{Purest.configuration.api_version}/#{path}"]

        # Base URL + path + name, if supplied
        url.map!{|u| u + "/#{@options[:name]}"} if @options[:name]

        # Base URL + path + appended_path, if supplied
        url.map!{|u| u + "/#{appended_path}"} if appended_path

        # Turn whatever options we have into JSON
        req.body = @options.to_json

        # Set the request URL, and finally make the request
        req.url concat_url url
      end

      JSON.parse(raw_resp.body, :symbolize_names => true)
    end

    def update(options = nil, path = nil, appended_path = nil)
      @options = options
      create_session unless authenticated?

      raw_resp = @conn.put do |req|
        # Base URL + path
        url = "/api/#{Purest.configuration.api_version}/#{path}"

        # Base URL + path + name, if supplied
        url += "/#{@options[:name]}" if @options[:name]

        # Base URL + appended path
        url += "/#{appended_path}" if appended_path

        # Since :name and :new_name are used the same throughout almost every class
        # it seems reasonable to do this here
        @options[:name] = @options.delete(:new_name) if !@options.nil? && @options[:new_name]

        req.body = @options.to_json

        req.url url
      end

      JSON.parse(raw_resp.body, :symbolize_names => true)
    end

    def delete(options = nil, path = nil, appended_path = nil)
      @options = options

      raw_resp = @conn.delete do |req|
        url = "/api/#{Purest.configuration.api_version}/#{path}/#{@options[:name]}"
        url += "#{appended_path}" if appended_path

        req.url url
      end

      # Unfortuantely this can't all be done in a single request, so if you
      # want to eradicate a subsequent request has to be made :(
      if @options[:eradicate]
        raw_resp = @conn.delete do |req|
          req.url "/api/#{Purest.configuration.api_version}/#{path}/#{@options[:name]}"
          req.body = @options.to_json
        end
      end

      JSON.parse(raw_resp.body, :symbolize_names => true)
    end
  end
end
