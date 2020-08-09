# frozen_string_literal: true
require 'faraday'

module MailClerk

  # Gem identity information.
  module Identity
    def self.name
      "mailclerk"
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
  def self.deliver(slug,recipient,data={},options={})

    api_url = ENV['MAILCLERK_API_URL'] || 'https://api.mailclerk.app'
    conn = Faraday.new(url: api_url)
    conn.basic_auth(self.api_key, '')

    resp = conn.post('v1/emails/'+slug+'/deliver') do |req|
      req.body = {recipient: recipient, data: data, options: options}.to_json
    end

    return resp
  end

end
