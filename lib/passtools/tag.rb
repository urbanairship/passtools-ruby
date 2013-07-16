=begin
    Method      Path                            Description
    # GET         /                               list tags for this user
    # GET         /{tag}/passes                   list passes on that tag
    # PUT         /{tag}/passes                   update the passes on this tag
    # DELETE      /{tag}                          Delete a tag and remove it from all of the passes it was associated with.
    # DELETE      /{tag}/passes                   Remove a tag from all of its passes.
    # DELETE      /{tag}/pass/{strPassId}         Remove the tag from the specified pass id.
    # DELETE      /{tag}/pass/id/{externalId}     Remove a pass from a tag by it's external id.
=end

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
