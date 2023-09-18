class TagGroupRepository
  delegate :get, :root_tag_group_names, :save, :save_root_tag_groups, to: :@datasource

  def initialize(datasource: :local)
    case datasource
    when :local  then @datasource = Local.new
    when :remote then @datasource = Remote.new
    else 'unknown datasource given'
    end
  end

  def all
    root_tag_group_names.map do |tag_group_name|
      get(tag_group_name)
    end
  end

  private

  class Local
    def root_tag_group_names
      JSON.load_file Rails.root.join('db', 'tag_groups', 'root_tag_group_names.json')
    end

    def get(tag_group_name)
      json = JSON.load_file(Rails.root.join('db', 'tag_groups', 'nodes', "#{tag_group_name}.json"), symbolize_names: true)
      TagGroup.new(
        name: json[:name],
        tags: json[:tags].map { |tag| Tag.new(tag) },
      )
    end

    def save(tag_groups)
      tag_groups.each do |tag_group|
        db = Rails.root.join('db', 'tag_groups', 'nodes', "#{tag_group.name}.json")
        File.write(db, tag_group.to_json)
      end
      nil
    end

    def save_root_tag_groups(tag_group_names)
      db = Rails.root.join('db', 'tag_groups', 'root_tag_group_names.json')
      File.write(db, tag_group_names.to_json)
      nil
    end
  end

  class Remote
    def initialize
      @client = Danbooru::Client.new
    end

    def root_tag_group_names
      @client.root_tag_group_names
    end

    def get(tag_group_name)
      response = @client.tag_group(tag_group_name)
      TagGroup.new(
        name: response[:name],
        tags: response[:tags].map { |tag| Tag.new(name: tag) },
      )
    end
  end
end
