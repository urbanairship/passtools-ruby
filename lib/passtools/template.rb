=begin
  Method      Path                            Description
  # GET         /headers                        list out the headers of all templates for this user.
  # GET         /{templateId}                   Get a template based on its id
  # GET         /id/{externalId}                Get a template based on its external id
  # DELETE      /{templateId}                   Delete a template based on its template id
  # DELETE      /id/{externalId}                Delete a template based on its external id

  # POST        /                               Create a new template
  # POST        /id/{externalId}                Create a new template and assign it an external id

  # POST        /{projectId}                    Create a template and assign it to a project
  # POST        /{projectId}/id/{externalId}    Create a template and assign it to a project, and give the template an external id

  # POST        /duplicate/{templateId}         Create a new template with the contents of the specified template.
  # POST        /duplicate/id/{externalId}      Create a new template with the contents of the specified template, by external id.
  # PUT         /{strTemplateId}                Modify the specified template
  # PUT         /id/{externalId}                Modify the specified template

  # POST        /{templateId}/locations         Add locations to a template
  # POST        /id/{externalId}/locations      Add locations to a template based on the templates external id
  # DELETE      /{templateId}/location/{locationId} Delete a location from a template
  # DELETE      /id/{externalId}/location/{locationId} Delete a location from a template based on external id
=end

module Passtools
  class Template
    extend Request
    attr_accessor :raw_data

    def self.list(params={})
      get("/template/headers", params)
    end

    def self.show(template_id, external= false)
      get(build_url(__method__, template_id, external))
    end

    def self.delete(template_id)
      delete_request("/template/#{template_id}")
    end

    def self.build_from_current(template_id, external=false)
      begin
        response = show(template_id, external)
        new(response)
      rescue RestClient::Exception => e
        data = MultiJson.load(e.response)
        data['message'] = e.message
        new(data)
      end
    end

    def self.create(data, external_id = nil)
      json = MultiJson.dump(data)
      url = build_url(__method__, external_id, !external_id.nil?)
      post(url, {:json => json})
    end

    def self.create_in_project(project_id, data, external_id = nil)
      json = MultiJson.dump(data)
      url = build_url(__method__, [project_id, external_id], !external_id.nil?)
      post(url, {:json => json})
    end

    def initialize(raw_data)
      @raw_data = raw_data
    end

    def id
      fetch_from_raw('templateHeader', 'id')
    end

    # return array of field names
    def field_names
      fetch_from_raw('fieldsModel').keys
    end

    # return hash required for creating a Pass based on this template
    def fields
      fetch_from_raw('fieldsModel')
    end

    def delete(template_id, external=false)
      delete_request(build_url(__method, template_id, external))
    end

    def update(template_id, data, external=false)
      json = MultiJson.dump(data)
      url = build_url(__method__, template_id, external)
      put(url, {:json => json})
    end

    def self.add_locations(template_id, location_list, external=false)
      json = MultiJson.dump(location_list)
      url = build_url(__method__, template_id, external)
      post(url, {:json => json})
    end

    def self.delete_location(template_id, location_id, external=false)
      url = build_url(__method__, [template_id, location_id], external)
      delete_request(url)
    end

    def valid?
      @raw_data.has_key?('fieldsModel')
    end

    protected

    def fetch_from_raw(*args)
      data = @raw_data
      res = nil
      args.each { |a| data = data.fetch(a, {}); res = data }
      res
    end

    def self.build_url(method, id, external)
      key = url_key(method, external)
      url_hash[key] % id
    end

    def self.url_hash
      {
          :show => "/template/%s",
          :show_external => "/template/id/%s",
          :delete => "/template/%s",
          :delete_external => "/template/id/%s",
          :create => "/template",
          :create_external => "/template/id/%s",
          :create_in_project => "/template/%s",
          :create_in_project_external => "/template/%s/id/%s",
          :update => "/template/%s",
          :update_external => "/template/id/%s",
          :add_locations => "/template/%s/locations",
          :add_locations_external => "/template/id/%s/locations",
          :delete_location => "/template/%s/location/%s",
          :delete_location_external => "/template/id/%s/location/%s"
      }
    end

    def self.url_key(method, external)
      external ? "#{method}_external".to_sym : method
    end

  end
end
