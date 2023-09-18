namespace :danbooru do
  namespace :tags do
    task :download => :environment do
      tags = TagRepository.new(datasource: :remote).all
      TagRepository.new(datasource: :local).save(tags)
    end
  end

  namespace :tag_groups do
    namespace :download do
      task :root_tag_group_names => :environment do
        root_tag_group_names = TagGroupRepository.new(datasource: :remote).root_tag_group_names
        TagGroupRepository.new(datasource: :local).save_root_tag_groups(root_tag_group_names)
      end

      task :tag_group => :environment do
        tag_group_name = ENV.fetch('name')

        tag_group = TagGroupRepository.new(datasource: :remote).get(tag_group_name)
        TagGroupRepository.new(datasource: :local).save([tag_group])
      end

      task :all => :environment do
        remote_repository = TagGroupRepository.new(datasource: :remote)
        local_repository  = TagGroupRepository.new(datasource: :local)

        root_tag_group_names = remote_repository.root_tag_group_names
        local_repository.save_root_tag_groups(root_tag_group_names)

        root_tag_group_names.each do |tag_group_name|
          puts tag_group_name
          tag_group = remote_repository.get(tag_group_name)
          local_repository.save([tag_group])
        end
      end
    end
  end
end
