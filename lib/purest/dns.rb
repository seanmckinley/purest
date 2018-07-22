module Purest
  class DNS < Purest::APIMethods
    @access_methods = %i[get update]

    GET_PARAMS = []

    def get(options = nil)
      super(options, 'dns', GET_PARAMS)
    end

    def update(options = nil)
      super(options, 'dns')
    end
  end
end
