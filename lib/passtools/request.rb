module Passtools
  module Request

    def get(path, params = {})
      url = construct_url(path)
      params.merge!(:api_key => Passtools.api_key)
      response = RestClient.get(url, :params => params)
      MultiJson.load(response)
    end

    def download_file(path, filename)
      filepath = Pathname.new(Passtools.download_dir.to_s)
      raise "Download directory is not defined or does not exist" unless filepath.exist?
      url = construct_url(path)
      params = {:api_key => Passtools.api_key}
      response = RestClient.get(url, :params => params)
      File.open(filepath.join(filename), 'w') {|f| f.write(response) }
    end

    def post(path, params = {})
      url = construct_url(path)
      params.merge!(:api_key => Passtools.api_key )
      response = RestClient.post(url, params, :multipart => true )
      MultiJson.load(response)
    end

    def put(path, params = {})
      url = construct_url(path)
      params.merge!(:api_key => Passtools.api_key )
      response = RestClient.put(url, params, :multipart => true )
      MultiJson.load(response)
    end

    def delete(path, params = {})
      url = construct_url(path)
      params.merge!(:api_key => Passtools.api_key )
      response = RestClient.delete(url, :params => params)
      MultiJson.load(response)
    end

    def construct_url(path)
      raise "You must configure API url before calling" if Passtools.url.to_s.empty?
      Passtools.url + path
    end

  end
end

