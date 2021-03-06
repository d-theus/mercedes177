Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = false
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true
  config.log_level = :info

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp',
    port:                 25,
    domain:               'mercedes177.ru',
    user_name:            ENV.fetch("SMTP_USER_NAME", ""),
    password:             ENV.fetch("SMTP_PASSWORD", ""),
    enable_starttls_auto: false
  }
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false
  config.action_controller.asset_host = "http://assets.mercedes177.ru"
end
