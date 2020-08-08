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

  # Syntax intended to emulate ActionMailer
  def self.deliver(slug,options,data={})

    if options.instance_of? String or options.instance_of? Array
      options = {to: options}
    end

    api_url = ENV['MAILCLERK_API_URL'] || 'https://api.mailclerk.app'
    conn = Faraday.new(url: api_url)
    conn.basic_auth(ENV['MAILCLERK_API_KEY'], '')

    resp = conn.post('v1/emails/'+slug+'/deliver') do |req|
      req.body = {data: data, options: options}.to_json
    end

    return resp
  end

end
