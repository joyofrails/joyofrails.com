# frozen_string_literal: true

class Users::ThankYousController < ApplicationController
  def show
    render Users::ThankYous::ShowView.new
  end
end
