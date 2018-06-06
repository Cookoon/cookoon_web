# frozen_string_literal: true

module CardCookoonComponent
  extend ComponentHelper

  def image_url
    @image_url || 'https://lorempixel.com/800/450/city/'
  end

  def title_class
    @title_style
  end

  def link_url?
    @link_url.present?
  end

  def cta?
    @cta.present?
  end

  def icons?
    @icons&.any?
  end

  def infos?
    @infos.present?
  end
end
