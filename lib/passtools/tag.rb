module Passtools
  class Tag
    extend Request

    def self.list(params={})
      get("/tag", params)
    end

    def self.list_passes(tag, params = {})
      get("/tag/#{tag}/passes", params )
    end

    def self.update_passes(tag, data)
      json = MultiJson.dump(data)
      put("/tag/#{tag}/passes", { :json => json } )
    end

    def self.remove_from_pass(tag, pass_id, external=false)
      pass_id = "id/#{pass_id}" if external
      delete_request("/tag/#{tag}/pass/#{pass_id}")
    end

    def self.remove_from_all(tag)
      delete_request("/tag/#{tag}/passes")
    end

    def self.delete(tag)
      delete_request("/tag/#{tag}")
    end

  end
end
