# frozen_string_literal: true

if Rails.env.test?
  ENV["RECAPTCHA_SITE_KEY"] = "6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI"
  ENV["RECAPTCHA_SECRET_KEY"] = "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe"
else
  config = Rails.application.credentials.config
  ENV["RECAPTCHA_SITE_KEY"] = config.dig(:recaptcha, :site_key)
  ENV["RECAPTCHA_SECRET_KEY"] = config.dig(:recaptcha, :secret_key)
end

