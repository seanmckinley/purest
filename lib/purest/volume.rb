# frozen_string_literal: true

module Purest
  class Volume < Purest::APIMethods
    @access_methods = %i[get create update delete]

    GET_PARAMS = [:action, :block_size, :connect, :historical, :length, :names,
                  :pending, :pending_only, :pgrouplist, :private, :protect,
                  :shared, :snap, :space]

    # Get a list of volumes, GET
    # @param options [Hash] options to pass
    def get(options = nil)
      super(options, 'volume', GET_PARAMS, [:show_diff, :show_hgroup, :show_host])
    end

    def create(options = nil)
      if options[:name] && options[:protection_group]
        appended_path = "#{options.delete(:name)}/pgroup/#{options.delete(:protection_group)}"
      end

      super(options, 'volume', appended_path)
    end

    def update(options = nil)
      super(options, 'volume')
    end

    # Delete a volume, DELETE
    # @param options [Hash] options to pass
    def delete(options = nil)
      if options[:name] && options[:protection_group]
        appended_path = "#{options.delete(:name)}/pgroup/#{options.delete(:protection_group)}"
      end

      super(options, 'volume', appended_path)
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
