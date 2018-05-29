module CloudinaryHelper
  def cloudinary_config_params
    params = {}
    CLOUDINARY_JS_CONFIG_PARAMS.each do |param|
      value = Cloudinary.config.send(param)
      params[param] = value unless value.nil?
    end
    params.to_json
  end
end
