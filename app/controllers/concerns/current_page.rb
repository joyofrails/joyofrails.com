module CurrentPage
  extend ActiveSupport::Concern

  included do
    helper_method :current_page
  end

  def current_page
    @current_page
  end
end
