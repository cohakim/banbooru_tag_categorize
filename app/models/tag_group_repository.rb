class TagGroupRepository
  delegate :root_groups, :tree, to: :@client

  def initialize(datasource: :local)
    case datasource
    when :local then  @client = LocalClient.new
    when :remote then @client = RemoteClient.new
    else 'unknown datasource given'
    end
  end

  def get(tag_group_name)
    TagGroup.new @client.get(tag_group_name)
  end

  private

  class LocalClient
    def root_groups
      JSON.load Rails.root.join('db', 'tag_groups', 'root.json')
    end

    def get(tag_group_name)
      JSON.load Rails.root.join('db', 'tag_groups', 'nodes', "#{tag_group_name}.json")
    end

    def tree
      root_groups.each_with_object({}) do |tag_group_name, hash|
        hash.merge! get(tag_group_name)
      end
    end
  end

  class RemoteClient
    DANBOORU_WIKI_URL = 'https://danbooru.donmai.us/wiki_pages'

    def root_groups
      text = connection.get("#{DANBOORU_WIKI_URL}/tag_groups.json").body[:body]
      text.scan(/\[\[(Tag group:.+?)\]\]/).flatten.map do |tag|
        tag.gsub(' ', '_').downcase
      end
    end

    def get(tag_group_name)
      text = connection.get("#{DANBOORU_WIKI_URL}/#{tag_group_name}.json").body[:body]
      tags = text.scan(/\[\[(?!tag group:)(?!tag groups)(.+?)\]\]/).flatten.map do |tag|
        tag.gsub(' ', '_').downcase
      end.uniq
      { name: tag_group_name, tags: tags }
    end

    def tree
      raise NotImplementError 'Use local datasource to call tree method'
    end

    private

    def connection
      Faraday::Connection.new do |builder|
        builder.request  :url_encoded
        builder.response :json, parser_options: { symbolize_names: true }, content_type: 'application/json'
        builder.response :raise_error
      end
    end
  end
end
