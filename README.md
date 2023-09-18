# README

[Danbooru Wiki https://danbooru.donmai.us/wiki_pages/tag_groups] からタグが所属するタググループを取得するためのプログラム

# Usage

Danbooru Wiki をスクレイピングして、ローカルにタグとタググループのセットを保存する

```
rake tag_groups:update:root_groups
rake tag_groups:update:node tag_group=tag_group:hair
rake tag_groups:update:nodes
```

# TODO

- タグの利用件数も取りたい
