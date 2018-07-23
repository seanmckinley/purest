module Purest
  class Users < Purest::APIMethods
    @access_methods = %i[get create update delete]

    GET_PARAMS = [:api_token, :expose, :publickey]

    def get(options = nil)
      if !options.nil? && options[:name] && options[:api_token]
        path = "admin/#{options[:name]}/apitoken"
        options.delete_if {|k| k == :name || k == :api_token}
      else
        path = "admin"
      end

      super(options, path, GET_PARAMS)
    end

    def create(options = nil)
      path = "admin/#{options.delete(:name)}/apitoken"
      super(options, path)
    end

    def update(options = nil)
      super(options, 'admin')
    end

    def delete(options = nil)
      path = "admin/#{options.delete(:name)}/apitoken"
      super(options, path)
    end
  end
end
