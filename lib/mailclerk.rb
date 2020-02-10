# frozen_string_literal: true
require 'faraday'

module MailClerk

  # Gem identity information.
  module Identity
    def self.name
      "mailclerk-ruby"
    end

    def self.label
      "Mailclerk"
    end

    def self.version
      "0.0.1"
    end

    def self.version_label
      "#{label} #{version}"
    end
  end

  def self.deliver(slug,data={},options={})
    conn = Faraday.new(
      url: 'http://api.mailclerk.app/v1',
      headers: {'Content-Type' => 'application/json', 'API_KEY' => ENV['MAILCLERK_API_KEY']}
    )

    resp = conn.post('/'+slug+'/deliver') do |req|
      req.body = {data: data, options: options}.to_json
    end

    return resp
  end

end
