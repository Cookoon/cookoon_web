# frozen_string_literal: true

module NavbarProComponent
  extend ComponentHelper

  def content?
    @content.present?
  end
end
