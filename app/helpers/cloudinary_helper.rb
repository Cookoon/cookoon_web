module CloudinaryHelper
  CLOUDINARY_JS_CONFIG_PARAMS = %i[api_key cloud_name private_cdn secure_distribution cdn_subdomain].freeze

  def cloudinary_config_params
    params = {}
    CLOUDINARY_JS_CONFIG_PARAMS.each do |param|
      value = Cloudinary.config.send(param)
      params[param] = value unless value.nil?
    end
    params.to_json
  end
end
