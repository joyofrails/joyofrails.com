# ActiveRecord model to represent a static page in the database.
class Page < ApplicationRecord
  def resource
    Sitepress.site.get(request_path)
  end
end
