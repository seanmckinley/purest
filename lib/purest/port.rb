# frozen_string_literal: true

module Purest
  class Port < Purest::APIMethods
    @access_methods = %i[get]

    GET_PARAMS = [:initiators].freeze

    def get(options = nil)
      super(options, 'port', GET_PARAMS)
    end
  end
end
