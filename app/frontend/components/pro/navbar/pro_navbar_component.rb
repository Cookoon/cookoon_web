# frozen_string_literal: true

module ProNavbarComponent
  extend ComponentHelper

  def content?
    @content.present?
  end
end
