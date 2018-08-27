# frozen_string_literal: true

module Purest
  class Cert < Purest::APIMethods
    @access_methods = %i[get create update delete]

    GET_PARAMS = %i[ca_certificate certificate common_name country email
                    intermediate_certificate locality organization
                    organizational_unit state].freeze

    def get(options = nil)
      if !options.nil? && options[:csr]
        super(options, 'cert/certificate_signing_request', GET_PARAMS)
      else
        super(options, 'cert', GET_PARAMS)
      end
    end

    def create(options = nil)
      super(options, 'cert')
    end

    def update(options = nil)
      super(options, 'cert')
    end

    def delete(options = nil)
      super(options, 'cert')
    end
  end
end
