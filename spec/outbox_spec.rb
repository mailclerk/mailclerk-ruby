require "spec_helper"

RSpec.describe "| Outbox" do

  it "| Test send works" do
    Mailclerk.deliver(
      ENV["TEST_TEMPLATE"], "john@example.com"
    )
    expect(Mailclerk.outbox.length).to eq(1)
  end
  
  it "| Test send values" do
    Mailclerk.deliver(
      ENV["TEST_TEMPLATE"],
      "jane@example.com",
      { "flag": 10 },
      { "foo": "bar"  }
    )
    email = Mailclerk.outbox.last
    
    # Originating locally
    expect(email.template).to eq(ENV["TEST_TEMPLATE"])
    expect(email.recipient).to eq("jane@example.com")
    expect(email.recipient_email).to eq("jane@example.com")
    expect(email.recipient_name).to eq(nil)
    expect(email.data).not_to be_nil
    expect(email.data.flag).to eq(10)
    expect(email.data["flag"]).to eq(10)
    expect(email.options).not_to be_nil
    expect(email.options.foo).to eq("bar")
    
    # Originating on the server
    expect(email.from).not_to be_nil
    expect(email.from.address).not_to be_nil
    expect(email.subject).not_to be_nil
    expect(email.html).not_to be_nil
    expect(email.html).to include("<html")
    expect(email.text).not_to be_nil
  end
  
  it "| Composite email" do
    Mailclerk.deliver(
      ENV["TEST_TEMPLATE"],
      "Alex Green <alex@example.com>"
    )
    email = Mailclerk.outbox.last
    
    expect(email.recipient).to eq("Alex Green <alex@example.com>")
    expect(email.recipient_email).to eq("alex@example.com")
    expect(email.recipient_name).to eq("Alex Green")
  end

  it "| Object email with hashes" do
    Mailclerk.deliver(
      ENV["TEST_TEMPLATE"],
      { "name" => "Alex Green", "address" => "alex@example.com" }
    )
    email = Mailclerk.outbox.last
    
    expect(email.recipient.name).to eq("Alex Green")
    expect(email.recipient_email).to eq("alex@example.com")
    expect(email.recipient_name).to eq("Alex Green")
  end

  it "| Object email with symbols" do
    Mailclerk.deliver(
      ENV["TEST_TEMPLATE"],
      { "name" => "Alex Green", "address" => "alex@example.com" }
    )
    email = Mailclerk.outbox.last
    
    expect(email.recipient_email).to eq("alex@example.com")
    expect(email.recipient_name).to eq("Alex Green")
  end
  
  it "| Filter" do
    Mailclerk.deliver(
      ENV["TEST_TEMPLATE"],
      "jane@example.com",
      { "flag": 10 },
      { "foo": "bar"  }
    )

    Mailclerk.deliver(
      ENV["TEST_TEMPLATE"],
      "faye@example.com",
      { "person": { "name": "Mugsby" } },
      { "foo": "bar"  }
    )

    # Fetching by name

    expect(Mailclerk.outbox.filter(
      template: ENV["TEST_TEMPLATE"]
    ).length).to eq(2)

    expect(Mailclerk.outbox.filter(
      template: "other-template"
    ).length).to eq(0)

    # Fetching by recipient_email

    expect(Mailclerk.outbox.filter(
      recipient_email: "jane@example.com"
    ).length).to eq(1)
    
    expect(Mailclerk.outbox.filter(
      recipient_email: "jane@example.com"
    )[0].data.flag).to eq(10)
    
    # Multiple conditions

    expect(Mailclerk.outbox.filter(
      recipient_email: "jane@example.com",
      template: ENV["TEST_TEMPLATE"]
    ).length).to eq(1)

    # Chaining conditions

    expect(Mailclerk.outbox.filter(
      template: ENV["TEST_TEMPLATE"]
    ).filter(
      recipient_email: "jane@example.com",
    ).length).to eq(1)

    # Select also works
    
    expect(Mailclerk.outbox.select do |e|
      e.recipient_email == "jane@example.com"
    end.length).to eq(1)

  end
end