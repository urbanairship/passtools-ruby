=begin

  Method      Path                            Description
  GET         /                               Get a list of projects for this user
  GET         /{projectID}                    Get a project based on its id
  GET         /id/{externalUID}               Get a project based on its external id
  POST        /                               Create a new project
  POST        /id/{externalID}                Create a new project with an externalID
  POST        /{layoutID}                     Create a project based on a layout
  PUT         /{projectID}                    Update a project
  PUT         /id/{externalUID}               Update a project based on its external id
  DELETE      /{projectID}                    Delete the specified project
  DELETE      /id/{externalID}                Delete the specified project based on its external id.

=end

module Passtools
  class Project
    extend Request
    attr_accessor :raw_data

    def self.list
      get('/project')
    end

    def self.show(project_id, external = false)
      get(build_url(__method__, project_id, external))
    end

    def self.update(project_id, data, external = false)
      json = MultiJson.dump(data)
      url = build_url(__method__, project_id, external)
      put(url, {:json => json})
    end

    def self.delete(project_id, external = false)
      delete_request(build_url(__method__, project_id, external))
    end

    def self.create(data, external_id = nil)
      json = MultiJson.dump(data)
      if external_id
        url = url_hash[:create_external] % external_id
      else
        url = url_hash[:create]
      end
      post(url, {:json => json})
    end

    def self.create_from_layout(layout_id, data)
      json = MultiJson.dump(data)
      url = build_url(__method__, layout_id, false)
      post(url, {:json => json})
    end

    protected

    def self.build_url(method, id, external)
      key = url_key(method, external)
      if id
        url_hash[key] % id
      else
        url_hash[key]
      end
    end

    def self.url_hash
      {
          :show => '/project/%s',
          :show_external => '/project/id/%s',
          :delete => '/project/%s',
          :delete_external => '/project/id/%s',
          :create => '/project',
          :create_external => '/project/id/%s',
          :update => '/project/%s',
          :update_external => '/project/id/%s',
          :create_from_layout => '/project/%s'
      }
    end

    def self.url_key(method, external)
      external ? "#{method}_external".to_sym : method
    end
  end

end
