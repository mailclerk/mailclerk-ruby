module Mailclerk
  class MailclerkError < StandardError
  end

  class MailclerkAPIError < MailclerkError
    attr_accessor :http_status
    attr_accessor :http_response
    
    def initialize(description, http_status=nil, http_response=nil)
      super(description)
      self.http_status = http_status
      self.http_response = http_response
    end
  end
end