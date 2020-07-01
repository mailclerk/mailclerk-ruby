# frozen_string_literal: true
require 'faraday'

module MailClerk

  # Gem identity information.
  module Identity
    def self.name
      "mailclerk-ruby"
    end

    def self.label
      "MailClerk"
    end

    def self.version
      "0.0.1"
    end

    def self.version_label
      "#{label} #{version}"
    end
  end

  def self.deliver(slug,options,data={})

    if options.instance_of? String or options.instance_of? Array
      options = {to: options}
    end

    api_url = ENV['RAILS_ENV'] === 'development' ? 'http://api.lvh.me:3000' : 'https://api.mailclerk.app' # Move this to option?
    conn = Faraday.new(
      url: api_url,
      headers: {'Content-Type' => 'application/json', 'API_KEY' => ENV['MAILCLERK_API_KEY']}
    )

    resp = conn.post('v1/'+slug+'/deliver') do |req|
      req.body = {data: data, options: options}.to_json
    end

    return resp
  end

end
