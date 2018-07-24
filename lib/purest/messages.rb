# frozen_string_literal: true

module Purest
  class Messages < Purest::APIMethods
    @access_methods = %i[get update]

    GET_PARAMS = %i[audit flagged login open recent user].freeze

    def get(options = nil)
      super(options, 'message', GET_PARAMS)
    end

    def update(options = nil)
      # In this case, 'id' is the identifier of a message,
      # not its name
      appended_path = options.delete(:id) if options[:id]
      super(options, 'message', appended_path)
    end
  end
end
