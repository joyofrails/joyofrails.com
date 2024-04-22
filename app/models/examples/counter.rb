class Examples::Counter
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :count, :integer, default: 0

  def to_param
    "today"
  end
end
