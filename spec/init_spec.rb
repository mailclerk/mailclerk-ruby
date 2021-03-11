require "spec_helper"

RSpec.describe "Init" do
  
  it "| Needs to be passed an API key" do
    expect do
      Mailclerk::Client.new(nil)
    end.to raise_error(Mailclerk::MailclerkError)
    
    Mailclerk::Client.new("mc_live_123") # fine
  end

end