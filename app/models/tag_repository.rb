class TagRepository
  delegate :all, :save, to: :@client

  def initialize(datasource: :local)
    case datasource
    when :local then  @client = Local.new
    when :remote then @client = Remote.new
    else 'unknown datasource given'
    end
  end

  private

  class Local
    def all
      tags = JSON.load_file(Rails.root.join('db', 'tags', 'tags.json'), symbolize_names: true)
      tags.map do |tag|
        Tag.new(tag)
      end
    end

    def save(tags)
      db = Rails.root.join('db', 'tags', 'tags.json')
      File.write(db, tags.to_json)
      nil
    end
  end

  class Remote
    def initialize
      @client = Danbooru::Client.new
    end

    def all
      @client.top_tags.map do |tag|
        Tag.new(
          name: tag[:name],
          post_count: tag[:post_count],
          is_deprecated: tag[:is_deprecated],
        )
      end
    end
  end
end
