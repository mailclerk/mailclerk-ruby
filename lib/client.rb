module Mailclerk
  class Client
    def initialize(api_key, api_url=nil)
      @api_key = api_key
      @api_url = api_url || ENV['MAILCLERK_API_URL'] || DEFAULT_API_URL
      
      if @api_key.nil?
        raise MailclerkError.new(
          "No Mailclerk API Key provided. Set `Mailclerk.api_key`"
        )
      end

      if @api_url.nil? || @api_url.empty?
        raise MailclerkError.new("Mailclerk API URL empty")
      end
    end
    
    def deliver(template, recipient, data={}, options={})
      conn = Faraday.new(url: @api_url)
      conn.basic_auth(@api_key, '')
            
      if Mailclerk.outbox_enabled?
        options = options.merge(
          "local_outbox" => true
        )
        options.delete(:local_outbox)
      end
      
      params = {
        'template' => template,
        'recipient' => recipient,
        'data' => data,
        'options' => options
      }

      response = conn.post('deliver', params.to_json, {
        'Content-Type' => 'application/json',
        'X-Client-Version' => Identity.version_label
      })
      
      if response.status >= 400
        begin
          message = JSON.parse(response.body)["message"] || "Unknown"
          description = "Mailclerk API Error: #{ message }"
        rescue JSON::ParserError
          description = "Mailclerk API Unknown Error"
        end
        
        raise MailclerkAPIError.new(
          description, response.status, response
        )
      end
      
      if Mailclerk.outbox_enabled?
        params["options"].delete("local_outbox")
        Mailclerk.outbox.add_send(params, JSON.parse(response.body)["delivery"])
      end
      
      return response
    end
  end
end