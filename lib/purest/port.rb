module Purest
  class Port < Purest::APIMethods
    @access_methods = %i[get]

    GET_PARAMS = [:initiators]

    def get(options = nil)
      super(options, 'port', GET_PARAMS)
    end
  end
end
