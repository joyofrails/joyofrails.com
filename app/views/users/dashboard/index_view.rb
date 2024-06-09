# frozen_string_literal: true

class Users::Dashboard::IndexView < ApplicationView
  def view_template
    h1 { "Settings" }
    p { "Your Joy of Rails dashboard" }
  end
end
