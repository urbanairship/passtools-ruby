module PasstoolsHelpers

  def stub_get(url, body={})
    stub_request(:get, url).
      with(:query => {:api_key => 'i_am_an_api_key'}).
      to_return(:body => MultiJson.dump(body))
  end 

  def stub_write(request_type, url, json = nil)
    body = {:api_key => 'i_am_an_api_key'}
    body.merge!(:json => json) if json
    stub = stub_request(request_type, url).
      with(:body => body,
           :headers => {'Content-Type'=>'application/x-www-form-urlencoded', 'Multipart'=>'true'}).
      to_return(:body => "{}")
  end

  def stub_delete(url,body={})
    stub_request(:delete, url).
      with(:query => {:api_key => 'i_am_an_api_key'}).
      to_return(:body => MultiJson.dump(body))
  end 

  def stub_error(url, error)
    stub_request(:get, url).
      with(:query => {:api_key => 'i_am_an_api_key'}).
      to_return(:status => [error],
                :body => "{\"code\":400,\"description\":\"Invalid Request Parameters.\",\"details\":\"template with id 999 was not found!\"}")
  end

end


