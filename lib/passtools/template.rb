module Passtools
  class Template
    extend Request

    def self.list
      get("/template/headers")
    end
 

    def self.show(template_id)
      get("/template/#{template_id}")
    end
  end

end
