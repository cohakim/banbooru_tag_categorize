namespace :tag_groups do
  namespace :update do
    task :root_groups => :environment do
      db = Rails.root.join('db', 'tag_groups', 'root.json')
      root_groups = TagGroupRepository.new(datasource: :remote).root_groups
      File.write(db, root_groups.to_json)
    end

    task :node => :environment do
      tag_group = ENV.fetch('tag_group')

      group_tags = TagGroupRepository.new(datasource: :remote).get(tag_group)

      db = Rails.root.join('db', 'tag_groups', 'nodes', "#{tag_group}.json")
      File.write(db, group_tags.to_json)
    end

    task :nodes => :environment do
      tag_groups = TagGroupRepository.new(datasource: :remote)

      tag_groups.root_groups.each do |tag_group|
        puts tag_group
        group_tags = tag_groups.get(tag_group)

        db = Rails.root.join('db', 'tag_groups', 'nodes', "#{tag_group}.json")
        File.write(db, group_tags.to_json)
      end
    end
  end
end
