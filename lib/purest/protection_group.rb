# frozen_string_literal: true
#
module Purest
  class ProtectionGroup < Purest::APIMethods
    @access_methods = %i[get create update delete]

    GET_PARAMS = [:names, :pending, :pending_only, :retention, :schedule,
                  :snap, :source, :space, :target, :total, :transfer]

    def get(options = nil)
      super(options, 'pgroup', GET_PARAMS)
    end

    def create(options = nil)
      super(options, 'pgroup')
    end

    def update(options = nil)
      super(options, 'pgroup')
    end

    def delete(options = nil)
      super(options, 'pgroup')
    end
  end
end
