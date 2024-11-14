# == Schema Information
#
# Table name: examples_posts
#
#  id            :integer          not null, primary key
#  postable_type :string           not null
#  title         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  postable_id   :integer          not null
#
# Indexes
#
#  index_examples_posts_on_postable  (postable_type,postable_id)
#
class Examples::Post < ApplicationRecord
  POSTABLE_TYPES = %w[
    Examples::Posts::Markdown
    Examples::Posts::Link
    Examples::Posts::Image
  ].freeze

  delegated_type :postable, types: POSTABLE_TYPES

  attr_writer :markdown, :link, :image

  accepts_nested_attributes_for :postable

  after_initialize :infer_postable

  def self.postable_types
    POSTABLE_TYPES
  end

  def markdown
    @markdown || (postable if postable.is_a?(Examples::Posts::Markdown))
  end

  def image
    @image || (postable if postable.is_a?(Examples::Posts::Image))
  end

  def link
    @link || (postable if postable.is_a?(Examples::Posts::Link))
  end

  def markdown?
    @markdown.present? || postable.is_a?(Examples::Posts::Markdown)
  end

  def image?
    @image.present? || postable.is_a?(Examples::Posts::Image)
  end

  def link?
    @link.present? || postable.is_a?(Examples::Posts::Link)
  end

  def markdown_attributes=(attributes)
    self.markdown = Examples::Posts::Markdown.new(attributes)
  end

  def link_attributes=(attributes)
    self.link = Examples::Posts::Link.new(attributes)
  end

  def image_attributes=(attributes)
    self.image = Examples::Posts::Image.new(attributes)
  end

  private

  def infer_postable
    return unless postable.nil?

    case postable_type
    when "Examples::Posts::Markdown"
      self.postable = markdown if markdown?
    when "Examples::Posts::Link"
      self.postable = link if link?
    when "Examples::Posts::Image"
      self.postable = image if image?
    end
  end
end
