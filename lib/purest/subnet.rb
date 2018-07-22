module Purest
  class Subnet < Purest::APIMethods
    @access_methods = %i[get create update delete]

    GET_PARAMS = []

    def get(options = nil)
      super(options, 'subnet', GET_PARAMS)
    end

    def create(options = nil)
      super(options, 'subnet')
    end

    def update(options = nil)
      super(options, 'subnet')
    end

    def delete(options = nil)
      super(options, 'subnet')
    end
  end
end
