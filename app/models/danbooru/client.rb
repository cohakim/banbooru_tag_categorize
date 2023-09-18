class Danbooru::Client
  private

  def connection
    Faraday::Connection.new do |builder|
      builder.request  :url_encoded
      builder.response :json, parser_options: { symbolize_names: true }, content_type: 'application/json'
      builder.response :raise_error
    end
  end

  concerning :TagGroup do
    DANBOORU_WIKI_URL = 'https://danbooru.donmai.us/wiki_pages'

    def root_tag_group_names
      text = connection.get("#{DANBOORU_WIKI_URL}/tag_groups.json").body[:body]
      text.scan(/\[\[(Tag group:.+?)\]\]/).flatten.map do |tag|
        tag.gsub(' ', '_').downcase
      end
    end

    def tag_group(tag_group_name)
      text = connection.get("#{DANBOORU_WIKI_URL}/#{tag_group_name}.json").body[:body]
      tags = text.scan(/\[\[(.+?)\]\]/).flatten.map do |tag|
        tag.gsub(' ', '_').downcase
      end.uniq
      tags.reject! { |tag| tag.match(/^tag_groups$/) || tag.match(/^tag_group:/) }
      { name: tag_group_name, tags: tags }
    end
  end

  concerning :Tag do
    DANBOORU_TAGS_URL = 'https://danbooru.donmai.us/tags.json?search[order]=count&limit=10&page=%{page}'

    def top_tags
      tags = (1..2).flat_map do |page|
        connection.get(DANBOORU_TAGS_URL % { page: page }).body
      end
    end
  end
end
