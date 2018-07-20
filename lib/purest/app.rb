module Purest
  class App < Purest::APIMethods
    @access_methods = %i[get]

    GET_PARAMS = []

    def get(options = nil)
      super(options, 'app', GET_PARAMS)
    end
  end
end
