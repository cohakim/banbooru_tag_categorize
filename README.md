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

- tag, tag_group で出力＆ファイル保存できるようにする
- 重複してるキーの一覧
- dup_keys = b.group_by(&:itself).select { _2.size > 1 }.keys
- どのキーが何個重複してるか、重複が多い順にならべる
- タグの利用件数も取りたい
