# frozen_string_literal: true
require 'faraday'

module Mailclerk
  class << self
    attr_accessor :api_key
  end

  # Gem identity information.
  module Identity
    def self.name
      "Mailclerk"
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

  # Syntax intended to emulate ActionMailer
  def self.deliver(template,recipient,data={},options={})
    api_url = ENV['Mailclerk_API_URL'] || 'https://api.Mailclerk.app'
    conn = Faraday.new(url: api_url)
    conn.basic_auth(self.api_key, '')
    resp = conn.post('deliver', {template: template, recipient: recipient, data: data, options: options}.to_json, {'Content-Type'=>'application/json'})
    return resp
  end

end
