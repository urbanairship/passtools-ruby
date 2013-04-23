module Passtools
  module Request

    def get(path, params = {})
      url = construct_url(path)
      params.merge!(:api_key => Passtools.api_key)
      response = RestClient.get(url, headers.merge(:params => params))
      MultiJson.load(response)
    end

    def download_file(path, filename)
      filepath = Pathname.new(Passtools.download_dir.to_s)
      raise "Download directory is not defined or does not exist" unless filepath.exist?
      url = construct_url(path)
      params = {:api_key => Passtools.api_key}
      response = RestClient.get(url, headers.merge(:params => params))
      File.open(filepath.join(filename), 'w:ascii-8bit') {|f| f.write(response) }
    end

    def post(path, params = {})
      url = construct_url(path)
      params.merge!(:api_key => Passtools.api_key )
      response = RestClient.post(url, params, headers.merge(:multipart => true) )
      MultiJson.load(response)
    end

    def put(path, params = {})
      url = construct_url(path)
      params.merge!(:api_key => Passtools.api_key )
      response = RestClient.put(url, params, headers.merge(:multipart => true) )
      MultiJson.load(response)
    end

    def delete_request(path, params = {})
      url = construct_url(path)
      params.merge!(:api_key => Passtools.api_key )
      response = RestClient.delete(url, headers.merge(:params => params))
      MultiJson.load(response)
    end

    def construct_url(path)
      raise "You must configure API url before calling" if Passtools.url.to_s.empty?
      Passtools.url + path
    end

    def headers
      { :user_agent => "passtools-gem-#{Passtools::VERSION}",
        :accept => :json,
        "Api-Revision" => 11 }
    end

  end
end

