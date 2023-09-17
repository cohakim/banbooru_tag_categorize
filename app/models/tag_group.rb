class TagGroup
  include ActiveModel::API
  include ActiveModel::Serializers::JSON

  attr_accessor :name, :tags

  def attributes
    { 'name' => nil, 'tags' => nil }
  end

  def hoge
    arr = Array.new
    tree.each do |key, val|
      val.each do |val2|
        arr.push [val2, key].join(',')
      end
    end
    arr
  end
end
