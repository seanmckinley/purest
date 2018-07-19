# frozen_string_literal: true
#
module Purest
  class HostGroup < Purest::APIMethods
    @access_methods = %i[get create update delete]

    GET_PARAMS = [:action, :block_size, :connect, :historical, :length, :names,
                  :pending, :pending_only, :pgrouplist, :private, :protect,
                  :shared, :snap, :space]

    # Get a list of hostgroups, GET
    # @param options [Hash] options to pass in
    def get(options = nil)
      super(options, 'hgroup', GET_PARAMS, [:show_volume])
    end

    def create(options = nil)
      @options = options
      create_session unless authenticated?

      raw_resp = @conn.post do |req|
        url = ["/api/#{Purest.configuration.api_version}/hgroup/#{@options[:name]}"]
        url.map!{|u| u + "/pgroup/#{@options[:protection_group]}"} if @options[:protection_group]
        url.map!{|u| u + "/volume/#{@options[:volume]}"} if @options[:volume]

        req.body = @options.to_json
        req.url concat_url url
      end

      JSON.parse(raw_resp.body, :symbolize_names => true)
    end

    # Update a host group, PUT
    # @param options [Hash] options to pass
    def update(options = nil)
      @options = options

      create_session unless authenticated?

      raw_resp = @conn.put do |req|
        req.url "/api/#{Purest.configuration.api_version}/hgroup/#{@options[:name]}"

        # Repurpose @options[:name] so that it is now set to the new_name
        # allowing us to rename a volume.
        @options[:name] = @options.delete(:new_name) if @options[:new_name]
        req.body = @options.to_json
      end

      JSON.parse(raw_resp.body, :symbolize_names => true)
    end

    # Delete a host group, DELETE
    # @param options[Hash] options to pass
    def delete(options = nil)
      @options = options

      create_session unless authenticated?

      raw_resp = @conn.delete do |req|
        url = ["/api/#{Purest.configuration.api_version}/hgroup/#{@options[:name]}"]
        url.map!{|u| u + "/pgroup/#{@options[:protection_group]}"} if @options[:protection_group]
        url.map!{|u| u + "/volume/#{@options[:volume]}"} if @options[:volume]

        req.url concat_url url
      end

      JSON.parse(raw_resp.body, :symbolize_names => true)
    end

    private
    # Dynamic method generation, e.g. use_all, use_action, etc
    GET_PARAMS.each do |param|
      define_method :"use_#{param}" do |options|
        options ? use_named_parameter(param, options[param]) : []
      end
    end
  end
end
