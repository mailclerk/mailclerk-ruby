module Mailclerk
  class Outbox < Array
    attr_accessor :enabled

    def initialize
      self.enabled = false
    end
    
    def enable
      self.enabled = true
    end
    
    def reset
      self.clear
    end
    
    # Not just an alias for 'select'
    def filter(query)
      self.select do |email|
        query.all? do |key, value|
          email[key] == value
        end
      end
    end
    
    def add_send(request, response)
      email = OutboxEmail.new(
        OutboxEmail.recursive_init(
          response.merge(request)
        )
      )
      self << email
    end
  end
  
  class OutboxEmail < OpenStruct
    
    def self.recursive_init(data)

      data.each do |key, val|
        if val.is_a?(Hash)
          data[key] = self.recursive_init(val)
        else
          data[key] = val
        end
      end
      
      return OpenStruct.new(data)
    end
    
    # Custom getters

    def recipient_email
      return parse_recipient[:address]
    end
    
    def recipient_name
      return parse_recipient[:name]
    end
    
    private
    
    def parse_recipient
      return {} unless self.recipient
      
      if self.recipient.is_a?(OpenStruct)
        return self.recipient
      end
      
      text = self.recipient.strip

      if text =~ /^[^<]+<[^<]+>$/
        parts = text.split("<", 2);

        name = parts[0].strip.gsub('"', "")

        address = parts[1].strip.gsub(">", "")

        return {
          name: name,
          address: address
        }
      else
        return {
          name: nil,
          address: text
        }
      end
    end
  end
end