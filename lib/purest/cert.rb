# frozen_string_literal: true

module Purest
  class Cert < Purest::APIMethods
    @access_methods = %i[get update]

    GET_PARAMS = %i[certificate common_name country email
                    intermediate_certificate locality organization
                    organizational_unit state].freeze

    def get(options = nil)
      if !options.nil? && options[:csr]
        super(options, 'cert/certificate_signing_request', GET_PARAMS)
      else
        super(options, 'cert', GET_PARAMS)
      end
    end

    def update(options = nil)
      super(options, 'cert')
    end
  end
end
