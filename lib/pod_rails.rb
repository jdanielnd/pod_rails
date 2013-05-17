require "pod_rails/version"
require 'net/http'
require 'json'
require 'active_support/configurable'
require 'open-uri'

module PodRails

  class BadRequest < StandardError; end

  # include ActiveSupport::Configurable

  # config_accessor :server
  
  # self.config.server ||= "http://pod.fores.ee"

  def self.create(options={})
    server ||= "http://pod.fores.ee"
    # uri = URI.parse("#{PodRails.config.server}/convert/")
    uri = URI.parse("#{server}/convert/")
    compressed_html = ActiveSupport::Gzip::Stream.compress(options[:document_content])
    # params = {filename: options[:name], html: options[:document_content]}
    params = {filename: options[:name], html: compressed_html}
    begin
      response=Net::HTTP.post_form(uri, params)
    rescue SocketError
      raise ServiceUnavailable, "Pod is not responding"
    end
    response
  end
end
