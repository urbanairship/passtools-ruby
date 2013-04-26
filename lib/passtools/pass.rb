module Passtools
  class Pass
    extend Request
    attr_accessor :raw_data

    def self.list
      get("/pass")
    end

    def self.list_by_template(template_id)
      #TODO not implemented in API yet
    end

    def self.show(pass_id, external=false)
      pass_id = "id/#{pass_id}" if external
      get("/pass/#{pass_id}")
    end

    def self.create(template_id, data, external_id=nil)
      json = MultiJson.dump(data)
      url = "/pass/#{template_id}"
      url += "/id/#{external_id}" if external_id
      post(url, {:json => json } )
    end

    def self.update(pass_id, data, external=false)
      json = MultiJson.dump(data)
      pass_id = "id/#{pass_id}" if external
      put("/pass/#{pass_id}", { :json => json } )
    end

    def self.add_locations(pass_id, location_list, external=false)
      json = MultiJson.dump(location_list)
      pass_id = "id/#{pass_id}" if external
      post("/pass/#{pass_id}/locations", { :json => json } )
    end

    def self.delete_location(pass_id, location_id, external=false)
      pass_id = "id/#{pass_id}" if external
      delete_request("/pass/#{pass_id}/location/#{location_id}" )
    end

    def self.download(pass_id,external=false)
      pass_id = "id/#{pass_id}" if external
      download_file("/pass/#{pass_id}/download", 'PassToolsPass.pkpass')
    end

    def self.pass_json(pass_id, external=false)
      pass_id = "id/#{pass_id}" if external
      get("/pass/#{pass_id}/viewJSONPass")
    end

    def self.push(pass_id,external=false)
      pass_id = "id/#{pass_id}" if external
      put("/pass/#{pass_id}/push")
    end

    def self.delete(pass_id,external=false)
      pass_id = "id/#{pass_id}" if external
      delete_request("/pass/#{pass_id}")
    end

    def self.list_tags(pass_id, external=false)
      pass_id = "id/#{pass_id}" if external
      get("/pass/#{pass_id}/tags")
    end

    def self.add_tags(pass_id, tags, external=false)
      json = MultiJson.dump({ 'tags' => Array(tags)})
      pass_id = "id/#{pass_id}" if external
      put("/pass/#{pass_id}/tags", { :json => json } )
    end

    def self.build_from_current(pass_id)
      begin
        response = show(pass_id)
        self.new(response)
      rescue RestClient::Exception => e
        data = MultiJson.load(e.response)
        data['message'] = e.message
        new(data)
      end
    end

    def self.build_from_template(template)
      @raw_data = {}
      @raw_data['templateId'] = template.id
      @raw_data['passFields'] = template.fields
      self.new(@raw_data)
    end

    def initialize(raw_data)
      @raw_data = raw_data
      fields = Array(@raw_data['passFields'])
      fields.each do |k,v|
        # self.instance_variable_set("@#{k}", v)  ## create and initialize an instance variable for this key/value pair
        define_singleton_method  k, proc{ @raw_data["passFields"][k.to_s] }
        define_singleton_method  "#{k}=", proc{ |v| @raw_data["passFields"][k.to_s] = v}
      end
    end

    def id
      @raw_data["id"]
    end

    def template_id
      @raw_data["templateId"]
    end

    def valid?
      @raw_data.has_key?('id')
    end

    def create
      return false if self.id
      response = self.class.create(template_id, @raw_data["passFields"])
      new_id = response['id']
      self.raw_data = response if new_id
    end

    def update
      return false unless self.id
      self.class.update(id, @raw_data["passFields"])
    end

    def push
      return false unless self.id
      self.class.push(id)
    end

    def delete
      return false unless self.id
      response = self.class.delete(id)
      self.raw_data['id'] = nil if response['Status'] == 'Deleted'
      response
    end

    def download
      return false unless self.id
      self.class.download(self.id)
    end

  end
end
