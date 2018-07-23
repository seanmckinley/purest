module Purest
  class Alert < Purest::APIMethods
    @access_methods = %i[get create update delete]

    GET_PARAMS = []

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
