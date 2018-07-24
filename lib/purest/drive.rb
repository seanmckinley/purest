# frozen_string_literal: true

module Purest
  class Drive < Purest::APIMethods
    @access_methods = %i[get]

    GET_PARAMS = [].freeze

    def get(options = nil)
      super(options, 'drive', GET_PARAMS)
    end
  end
end
