module StubHelper
  def get_helper(path, return_val=[])
    stub_request(:get, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}".concat(path))
      .to_return(status: 200, body: JSON.generate(return_val), headers: {})
  end

  def post_helper(path: nil, body: nil)
    if body.nil?
      stub_request(:post, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}".concat(path))
        .to_return(status: 200, body: JSON.generate([]), headers: {})
    else
      stub_request(:post, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}".concat(path)).with(
        body: body
      ).to_return(status: 200, body: JSON.generate([]), headers: {})
    end
  end

  def put_helper(path: nil, body: nil)
    if body.nil?
      stub_request(:put, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}".concat(path))
        .to_return(status: 200, body: JSON.generate([]), headers: {})
    else
      stub_request(:put, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}".concat(path)).with(
        body: body
      ).to_return(status: 200, body: JSON.generate([]), headers: {})
    end
  end

  def delete_helper(path: nil, body: nil)
    if body.nil?
      stub_request(:delete, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}".concat(path))
        .to_return(status: 200, body: JSON.generate([]), headers: {})
    else
      stub_request(:delete, "#{Purest.configuration.url}/api/#{Purest.configuration.api_version}".concat(path)).with(
        body: body
      ).to_return(status: 200, body: JSON.generate([]), headers: {})
    end
  end
end
