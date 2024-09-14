class ErrorsController < ApplicationController
  def not_found
    render Errors::NotFoundView, status: 404
  end

  def internal_server
    render Errors::InternalServerView, status: 500
  end

  def unprocessable
    render Errors::UnprocessableView, status: 422
  end
end
