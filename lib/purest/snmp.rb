# frozen_string_literal: true

module Purest
  class SNMP < Purest::APIMethods
    @access_methods = %i[get create update delete]

    GET_PARAMS = [:engine_id].freeze

    def get(options = nil)
      super(options, 'snmp', GET_PARAMS)
    end

    def create(options = nil)
      super(options, 'snmp')
    end

    def update(options = nil)
      super(options, 'snmp')
    end

    def delete(options = nil)
      super(options, 'snmp')
    end
  end
end
