module Purest
  class Message < Purest::APIMethods
    @access_methods = %i[get update]

    GET_PARAMS = [:audit, :flagged, :login, :open, :recent, :user]

    def get(options = nil)
      super(options, 'message', GET_PARAMS)
    end

    def update(options = nil)
      # In this case, 'id' is the identifier of a message,
      # not its name
      appended_path = options.delete(:id) if options[:id]
      super(options, 'message', appended_path)
    end
  end
end
