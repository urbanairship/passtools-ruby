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

    def self.show(pass_id, params = {})
      get("/pass/#{pass_id}", params)
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

    def self.push(pass_id)
      put("/pass/#{pass_id}/push")
    end

    def self.delete_pass(pass_id)
      delete("/pass/#{pass_id}")
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
      response = self.class.delete_pass(id)
      self.raw_data['id'] = nil if response['Status'] == 'Deleted'
      response
    end

  end
end
