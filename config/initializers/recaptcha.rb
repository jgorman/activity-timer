# frozen_string_literal: true

creds = Rails.application.credentials
ENV["RECAPTCHA_SITE_KEY"] = creds.dig(:recaptcha, :site_key)
ENV["RECAPTCHA_SECRET_KEY"] = creds.dig(:recaptcha, :secret_key)

