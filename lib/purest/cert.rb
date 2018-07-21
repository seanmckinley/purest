module Purest
  class Cert < Purest::APIMethods
    @access_methods = %i[get update]

    GET_PARAMS = [:certificate, :common_name, :country, :email,
                  :intermediate_certificate, :locality, :organization,
                  :organizational_unit, :state]

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
