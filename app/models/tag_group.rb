class TagGroup
  include ActiveModel::API
  include ActiveModel::Serializers::JSON

  attr_accessor :name, :tags

  def attributes
    { 'name' => nil, 'tags' => nil }
  end
end
