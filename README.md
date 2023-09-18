# README

## 概要

- タグが所属するタググループを取得できる
  - タググループは [Danbooru Wiki](https://danbooru.donmai.us/wiki_pages/tag_groups) から取得
- タグを使用件数が高いものから10000件取得できる
- タグの使用件数を取得できる

## Usage

- Danbooruからタグの部分データを取得しローカルにキャッシュする
  - ファイルは `db/tags`, `db/tag_groups` に保存される
- 後述の `rake tag:export` はローカルキャッシュが存在することを前提に動作

```
# 使用件数上位10000件のタグを取得
$ rake danbooru:tags:download

# タググループのトップカテゴリを取得
$ rake danbooru:tag_groups:download:root_tag_group_names

# タググループに所属するタグを取得
$ rake danbooru:tag_groups:download::all
```

- ローカルにキャッシュしたタグの部分データからタグ情報を出力する

```
# タグとタググループを紐づけて出力
$ rake tag:export
```
