# frozen_string_literal: true

module Purest
  class Hardware < Purest::APIMethods
    @access_methods = %i[get update]

    GET_PARAMS = [].freeze

    def get(options = nil)
      super(options, 'hardware', GET_PARAMS)
    end

    def update(options = nil)
      super(options, 'hardware')
    end
  end
end
