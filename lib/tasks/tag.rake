namespace :tag do
  task :export => :environment do
    filepath = Rails.root.join('output', 'tags.txt')

    File.delete(filepath)
    top_tags_with_tag_group.each do |tag|
      File.open(filepath, 'a') do |file|
        file.puts tag.join(', ')
      end
    end
  end
end

def top_tags_with_tag_group
  TagRepository.new.all.flat_map do |tag|
    tag_group_index.fetch(tag.name, ['']).map do |tag_group|
      [tag.name, tag.post_count, tag.is_deprecated, tag_group]
    end
  end
end

def tag_group_index
  TagGroupRepository.new.all.each_with_object({}) do |tag_group, result|
    tag_group.tags.map do |tag|
      result[tag.name] ||= Array.new
      result[tag.name] << tag_group.name
    end
  end
end
