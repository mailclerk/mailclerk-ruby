# frozen_string_literal: true

require 'faraday'
require 'json'

require "client"
require "errors"
require "outbox"

module Mailclerk
  DEFAULT_API_URL = "https://api.mailclerk.app"
  
  class << self
    attr_accessor :api_key
    attr_accessor :api_url
  end
  
  # Gem identity information.
  module Identity
    def self.name
      "mailclerk"
    end

    def self.label
      "Mailclerk Ruby"
    end

    def self.version
      "1.1.0"
    end

    def self.version_label
      "#{ label } #{ version }"
    end
  end

  # Syntax intended to emulate ActionMailer
  def self.deliver(*args)
    api_key = self.api_key || ENV['MAILCLERK_API_KEY']
    
    client = Mailclerk::Client.new(api_key, self.api_url)
    return client.deliver(*args)
  end
  
  def self.outbox
    @outbox ||= Mailclerk::Outbox.new
  end

  def self.outbox_enabled?
    !!(@outbox && @outbox.enabled)
  end
end