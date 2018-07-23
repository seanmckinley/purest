# frozen_string_literal: true

module Purest
  class HostGroup < Purest::APIMethods
    @access_methods = %i[get create update delete]

    GET_PARAMS = %i[action block_size connect historical length names
                    pending pending_only pgrouplist private protect
                    shared snap space].freeze

    # Get a list of hostgroups, GET
    # @param options [Hash] options to pass in
    def get(options = nil)
      super(options, 'hgroup', GET_PARAMS, [:show_volume])
    end

    def create(options = nil)
      # The API doesn't accept some of these options in the HTTP body
      # during a POST, so we remove them from the options hash after
      # creating a path to append to the base URL in APIMethods.create
      if options[:name] && options[:volume]
        appended_path = "#{options.delete(:name)}/volume/#{options.delete(:volume)}"
      elsif options[:name] && options[:protection_group]
        appended_path = "#{options.delete(:name)}/pgroup/#{options.delete(:protection_group)}"
      end
      super(options, 'hgroup', appended_path)
    end

    def update(options = nil)
      super(options, 'hgroup')
    end

    # Delete a host group, DELETE
    # @param options[Hash] options to pass
    def delete(options = nil)
      if options[:name] && options[:volume]
        appended_path = "#{options.delete(:name)}/volume/#{options.delete(:volume)}"
      elsif options[:name] && options[:protection_group]
        appended_path = "#{options.delete(:name)}/pgroup/#{options.delete(:protection_group)}"
      end

      super(options, 'hgroup', appended_path)
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
