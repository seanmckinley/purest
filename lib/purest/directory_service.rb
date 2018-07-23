module Purest
  class DirectoryService < Purest::APIMethods
    @access_methods = %i[get update]

    GET_PARAMS = [:certificate, :groups]

    def get(options = nil)
      super(options, 'directoryservice', GET_PARAMS)
    end

    def update(options = nil)
      super(options, 'directoryservice')
    end
  end
end
