require "passtools/version"

require 'rest_client'
require 'multi_json'
require 'yaml'

require 'passtools/request'
require 'passtools/template'
require 'passtools/pass'

module Passtools

  class << self
    attr_accessor :api_key, :url, :download_dir
  end
  # Configure through hash
  def self.configure(opts = {})
    opts.each {|k,v| instance_variable_set("@#{k}",v) }
  end

  def self.configure_from_file(pathname)
    config = YAML::load(IO.read(pathname))
    configure(config)
  end

  def self.url 
    @url ||= 'https://api.passtools.com/v1'
  end

  def self.api_key
    @api_key || raise("You must configure api_key before calling")
  end

end
