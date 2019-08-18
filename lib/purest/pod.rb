# frozen_string_literal: true

module Purest
  class Pod < Purest::APIMethods
    @access_methods = %i[get create update delete]

    GET_PARAMS = %i[action failover_preferance footprint historical
                    latency mediator names on pending pending_only
                    space].freeze

    def get(options = nil)
      super(options, 'pod', GET_PARAMS)
    end

    def create(options = nil)
      if options[:array]
        super(options, 'pod', "array/#{options[:array]}")
      else
        super(options, 'pod')
      end
    end

    def update(options = nil)
      super(options, 'pod')
    end

    def delete(options = nil)
      if options[:array]
        super(options, 'pod', "array/#{options[:array]}")
      else
        super(options, 'pod')
      end
    end
  end
end
