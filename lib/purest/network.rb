# frozen_string_literal: true

module Purest
  class Network < Purest::APIMethods
    @access_methods = %i[get create update delete]

    GET_PARAMS = [].freeze

    def get(options = nil)
      super(options, 'network', GET_PARAMS)
    end

    def create(options = nil)
      super(options, 'network/vif')
    end

    def update(options = nil)
      super(options, 'network')
    end

    def delete(options = nil)
      super(options, 'network')
    end
  end
end
