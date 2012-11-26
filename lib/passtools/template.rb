module Passtools
  class Template
    extend Request
    attr_accessor :raw_data

    def self.list(params={})
      get("/template/headers", params)
    end

    def self.show(template_id)
      get("/template/#{template_id}")
    end

    def self.build_from_current(template_id)
      begin
        response = show(template_id)
        new(response)
      rescue RestClient::Exception => e
        data = MultiJson.load(e.response)
        data['message'] = e.message
        new(data)
      end
    end

    def initialize(raw_data)
      @raw_data = raw_data
    end

    def id
      fetch_from_raw('templateHeader','id')
    end

    # return array of field names
    def field_names
      fetch_from_raw('fieldsModel').keys
    end

    # return hash required for creating a Pass based on this template
    def fields
      fetch_from_raw('fieldsModel')
    end

    def fetch_from_raw(*args)
      data = @raw_data
      res = nil
      args.each { |a| data = data.fetch(a, {}); res = data }
      res
    end

    def valid?
      @raw_data.has_key?('fieldsModel')
    end

  end
end
