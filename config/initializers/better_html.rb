# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  BetterHtml.configure do |config|
    config.partial_attribute_name_pattern = /\A[a-z_0-9\-\:]+\z/
  end
end
