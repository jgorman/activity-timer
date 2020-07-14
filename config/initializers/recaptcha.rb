# frozen_string_literal: true

config = Rails.application.credentials.config
ENV["RECAPTCHA_SITE_KEY"] = config.dig(:recaptcha, :site_key)
ENV["RECAPTCHA_SECRET_KEY"] = config.dig(:recaptcha, :secret_key)

