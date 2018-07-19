# frozen_string_literal: true
#
module Purest
  class ProtectionGroup < Purest::APIMethods
    @access_methods = %i[get create update delete]

    GET_PARAMS = [:pending]

    def get(options = nil)
      super(options, 'pgroup', GET_PARAMS)
    end
  end
end
