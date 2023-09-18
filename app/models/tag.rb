class Tag
  include ActiveModel::API
  include ActiveModel::Serializers::JSON

  attr_accessor :name, :post_count, :is_deprecated

  def attributes
    { 'name' => nil, 'post_count' => 0, 'is_deprecated' => false }
  end
end
