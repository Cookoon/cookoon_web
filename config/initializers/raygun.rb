Raygun.setup do |config|
  config.api_key = ENV['RAYGUN_API_KEY']
  config.filter_parameters = Rails.application.config.filter_parameters

  # The default is Rails.env.production?
  # config.enable_reporting = !Rails.env.development? && !Rails.env.test?
  config.enable_reporting = Rails.env.production? || Rails.env.staging?
end
