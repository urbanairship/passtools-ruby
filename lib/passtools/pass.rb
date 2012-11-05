module Passtools
  class Pass
    extend Request

    def self.list
      get("/pass") 
    end

    def self.list_by_template(template_id)
      #TODO not implemented in API yet
    end

    def self.show(pass_id)
      get("/pass/#{pass_id}")
    end
    
    def self.create(template_id,data)
      json = MultiJson.dump(data)
      post("/pass/#{template_id}", {:json => json } )
    end

    def self.update(pass_id,data)
      json = MultiJson.dump(data)
      put("/pass/#{pass_id}", { :json => json } )
    end

    def self.download(pass_id)
      download_file("/pass/#{pass_id}/download", 'PassToolsPass.pkpass')
    end

  end

end
