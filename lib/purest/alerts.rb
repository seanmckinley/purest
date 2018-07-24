# frozen_string_literal: true

module Purest
  class Alerts < Purest::APIMethods
    @access_methods = %i[get create update delete]

    GET_PARAMS = [].freeze

    def get(options = nil)
      super(options, 'alert', GET_PARAMS)
    end

    def create(options = nil)
      super(options, 'alert')
    end

    def update(options = nil)
      super(options, 'alert')
    end

    def delete(options = nil)
      super(options, 'alert')
    end
  end
end
