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
      url = build_url(__method__, pass_id, external)
      get(url)
    end

    def self.create(template_id, data, external_id=nil)
      json = MultiJson.dump(data)
      url = build_url(__method__, [template_id, external_id], !external_id.nil?)
      post(url, {:json => json } )
    end

    def self.update(pass_id, data, external=false)
      json = MultiJson.dump(data)
      url = build_url(__method__, pass_id, external)
      put(url, { :json => json } )
    end

    def self.add_locations(pass_id, location_list, external=false)
      json = MultiJson.dump(location_list)
      url = build_url(__method__, pass_id, external)
      post(url, { :json => json } )
    end

    def self.delete_location(pass_id, location_id, external=false)
      url = build_url(__method__, [pass_id, location_id] , external)
      delete_request(url)
    end

    def self.download(pass_id,external=false)
      url = build_url(__method__, pass_id, external)
      download_file(url, 'PassToolsPass.pkpass')
    end

    def self.pass_json(pass_id, external=false)
      url = build_url(__method__, pass_id, external)
      get(url)
    end

    def self.push(pass_id,external=false)
      url = build_url(__method__, pass_id, external)
      put(url)
    end

    def self.delete(pass_id,external=false)
      url = build_url(__method__, pass_id, external)
      delete_request(url)
    end

    def self.list_tags(pass_id, external=false)
      url = build_url(__method__, pass_id, external)
      get(url)
    end

    def self.add_tags(pass_id, tags, external=false)
      json = MultiJson.dump({ 'tags' => Array(tags)})
      url = build_url(__method__, pass_id, external)
      put(url, { :json => json } )
    end

    def self.build_url(method, id, external)
      key = url_key(method, external)
      url_hash[key] % id
    end

    def self.url_hash
      { :create                    => "/pass/%s",
        :create_external           => "/pass/%s/id/%s",
        :show                      => "/pass/%s",
        :show_external             => "/pass/id/%s",
        :update                    => "/pass/%s",
        :update_external           => "/pass/id/%s",
        :add_locations             => "/pass/%s/locations",
        :add_locations_external    => "/pass/id/%s/locations",
        :delete_location           => "/pass/%s/location/%s",
        :delete_location_external  => "/pass/id/%s/location/%s",
        :download                  => "/pass/%s/download",
        :download_external         => "/pass/id/%s/download",
        :pass_json                 => "/pass/%s/viewJSONPass",
        :pass_json_external        => "/pass/id/%s/viewJSONPass",
        :push                      => "/pass/%s/push",
        :push_external             => "/pass/id/%s/push",
        :delete                    => "/pass/%s",
        :delete_external           => "/pass/id/%s",
        :add_tags                  => "/pass/%s/tags",
        :add_tags_external         => "/pass/id/%s/tags",
        :list_tags                 => "/pass/%s/tags",
        :list_tags_external        => "/pass/id/%s/tags"
      }
    end

    def self.url_key(method, external)
      external ? "#{method}_external".to_sym : method
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
