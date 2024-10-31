# ActiveRecord model to represent a static page in the database.
class Page < ApplicationRecord
  after_create_commit :create_in_search_index
  after_update_commit :update_in_search_index
  after_destroy_commit :remove_from_search_index

  def self.rebuild_search_index
    find_each(&:update_in_search_index)
  end

  def self.search(query)
    joins("JOIN pages_search_index ON pages.id = pages_search_index.page_id")
      .where("pages_search_index MATCH ?", query)
  end

  def title
    resource.data.title
  end

  def body
    resource.body
  end

  def body_html
    ApplicationController.render(inline: body, type: resource.handler, layout: false)
  end

  def body_text
    Nokogiri::HTML(body_html).text.squish
  end

  def resource
    Sitepress.site.get(request_path)
  end

  def create_in_search_index
    Rails.logger.info "[#{self.class}] Creating search index for page #{id} #{request_path}"
    execute_sanitized_sql "INSERT INTO pages_search_index (page_id, title, body) VALUES (?, ?, ?)", id, title, body_text
  end

  def update_in_search_index
    transaction do
      remove_from_search_index
      create_in_search_index
    end
  end

  def remove_from_search_index
    execute_sanitized_sql "DELETE FROM pages_search_index WHERE page_id = ?", id
  end

  def execute_sanitized_sql(*statement)
    execute self.class.sanitize_sql(statement)
  end

  def execute(statement)
    self.class.connection.execute statement
  end
end
