<p align="center">
  <img src="https://github.com/mailclerk/mailclerk-ruby/blob/main/mailclerk.png?raw=true" alt="Mailclerk Logo"/>
</p>

# Mailclerk

[![Gem Version](https://badge.fury.io/rb/mailclerk.svg)](http://badge.fury.io/rb/mailclerk)

Mailclerk helps anyone on your team design great emails, improve their performance, and free up developer time. [Learn more](https://mailclerk.app/)

<!-- Tocer[start]: Auto-generated, don't remove. -->

## Table of Contents

  - [Requirements](#requirements)
  - [Setup](#setup)
  - [API Key & URL](#api-key--url)
  - [Usage](#usage)
  - [Testing](#testing)
  - [Varying API Keys](#varying-api-keys)
  - [Gem Tests](#gem-tests)
  - [Versioning](#versioning)
  - [Code of Conduct](#code-of-conduct)
  - [Contributions](#contributions)
  - [License](#license)
  - [History](#history)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

## Requirements

1. [Ruby 2.4.0](https://www.ruby-lang.org)

## Setup

To install, run:

```
gem install mailclerk
```

Add the following to your Gemfile:

```
gem "mailclerk"
```

## API Key & URL

To set the Mailclerk API Key (begins with `mc_`), you can provide it as an
environmental variable: `MAILCLERK_API_KEY`. Alternatively, you can
set it directly on the Mailclerk module:

```ruby
# config/initializers/mailclerk.rb
Mailclerk.api_key = "mc_live_yourprivatekey"
```

_If you are using version control like git, we strongly recommend storing your
production API keys in environmental variables_.

The default API endpoint is `https://api.mailclerk.app`. To change this, you
can provide a `MAILCLERK_API_URL` ENV variable or set `Mailclerk.mailclerk_url`.

## Usage

You'll need an active account and at least one template (in the example `welcome-email`).

To send an email to "alice@example.com":

```ruby
Mailclerk.deliver("welcome-email", "alice@example.com")
Mailclerk.deliver("welcome-email", "Alice Adams <alice@example.com>")
Mailclerk.deliver("welcome-email", { name: "Alice Adams", address: "<alice@example.com>" })
```

If the template has any dynamic data, you can include it in the third parameter
as a hash:

```ruby
Mailclerk.deliver("welcome-email", "alice@example.com", { name: "Alice" })
```

See [Mailclerk documentation](https://dashboard.mailclerk.app/docs) for more details.

## Testing

Your Mailclerk environment has two API keys: a production key (beginning with `mc_live`)
and a test key (beginning with `mc_test`). If you use the test key, emails will
not be delivered, but will show up in the logs on your Mailclerk account and can be
previewed there. This replaces tools like [Letter Opener](https://github.com/ryanb/letter_opener) for previewing emails in development.

To avoid cluttering up your Mailclerk test logs with sends triggered by your
automated test suite, call `Mailclerk.outbox.enable` in the file that
configures your tests. For example, in Rspec with Rails, add:

```ruby
# spec/rails_helper.rb
Mailclerk.outbox.enable
```

This will also enable utility methods which you can use to write tests that check
emails are sent with the correct data:

```ruby
# Number of emails "sent"
Mailclerk.outbox.length

# Returns all emails of matching a template or email recipient. See method
Mailclerk.outbox.filter(template: "welcome-email")
Mailclerk.outbox.filter(recipient_email: "felix@example.com")

# Returns the most recent email (instance of Mailclerk::TestEmail):
email = Mailclerk.outbox.last
email.template        # "welcome-email"
email.recipient_email # "felix@example.com"
email.subject         # "Welcome to Acme Felix"
email.html            # "<html><body>..."
```

In between test cases, you should clear the stored emails by calling `Mailclerk.outbox.reset`.

For example, in Rspec with Rails:

```ruby
# spec/rails_helper.rb
RSpec.configure do |config|
  config.before(:each) do
    Mailclerk.outbox.reset
  end
end
```

`Mailclerk::OutboxEmail` has the following attributes:

| Attribute         | Description                                                                |
| ----------------- | -------------------------------------------------------------------------- |
| `template`        | Slug of the template sent (1st argument to `Mailclerk.deliver`)            |
| `recipient`       | Hash representing the send recipient (2nd argument to `Mailclerk.deliver`) |
| `recipient_email` | Email of the send recipient                                                |
| `recipient_name`  | Name of the send recipient (nil if not specified)                          |
| `data`            | Dynamic data for the send (3rd argument to `Mailclerk.deliver`)            |
| `options`         | Options specified for the send (4th argument to `Mailclerk.deliver`)       |
| `from`            | From Mailclerk: Hash with `name` and `address` of the sender               |
| `subject`         | From Mailclerk: Text of the send's subject line                            |
| `preheader`       | From Mailclerk: Text of the send's preheader                               |
| `html`            | From Mailclerk: Rendered body HTML for the send                            |
| `text`            | From Mailclerk: Rendered plaintext version of the send                     |
| `headers`         | From Mailclerk: Extra email headers (e.g. `reply-to`)                      |

See the [Mailclerk testing documentation](https://dashboard.mailclerk.app/docs#testing)
for more details.

## Varying API Keys

If you need to use multiple API keys, you can also initialize `Mailclerk::Client`
instances with different keys. This:

```ruby
mc_client = Mailclerk.new("mc_live_yourprivatekey")
mc_client.deliver("welcome-email", "bob@example.com")
```

Is equivalent to this:

```ruby
Mailclerk.api_key = "mc_live_yourprivatekey"
Mailclerk.deliver("welcome-email", "bob@example.com")
```

## Gem Tests

```
bundle exec rspec
```

Requires values in .env file as well

## Versioning

Read [Semantic Versioning](https://semver.org) for details. Briefly, it means:

- Major (X.y.z) - Incremented for any backwards incompatible public API changes.
- Minor (x.Y.z) - Incremented for new, backwards compatible, public API enhancements/fixes.
- Patch (x.y.Z) - Incremented for small, backwards compatible, bug fixes.

## Code of Conduct

Please note that this project is released with a [CODE OF CONDUCT](CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.

## Contributions

Read [CONTRIBUTING](CONTRIBUTING.md) for details.

## License

Copyright 2021 [Mailclerk](https://mailclerk.app/).
Read [LICENSE](LICENSE.md) for details.

## History

Read [CHANGES](CHANGES.md) for details.
Built with [Gemsmith](https://github.com/bkuhlmann/gemsmith).
