# frozen_string_literal: true

module CardCookoonComponent
  extend ComponentHelper

  attr_reader :title_class, :infos_class

  def small?
    @small
  end

  def spaced?
    @spaced
  end

  def image_url
    @image_url || 'https://lorempixel.com/800/450/city/'
  end

  def carousel_photos?
    @carousel_photos.present?
  end

  def link_url?
    @link_url.present?
  end

  def cta?
    @cta.present?
  end

  def selected?
    @selected
  end

  def icons?
    @icons&.any?
  end

  def infos?
    @infos.present?
  end
end
