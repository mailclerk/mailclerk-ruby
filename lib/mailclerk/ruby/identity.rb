# frozen_string_literal: true

module Mailclerk
  module Ruby
    # Gem identity information.
    module Identity
      def self.name
        "mailclerk-ruby"
      end

      def self.label
        "Mailclerk Ruby"
      end

      def self.version
        "0.1.0"
      end

      def self.version_label
        "#{label} #{version}"
      end
    end
  end
end
