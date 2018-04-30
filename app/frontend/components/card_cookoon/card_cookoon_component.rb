# frozen_string_literal: true

module CardCookoonComponent
  extend ComponentHelper

  def image_url
    @image_url || 'https://lorempixel.com/800/450/city/'
  end
end
