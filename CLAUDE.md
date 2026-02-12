# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RangePpoiString は配列とレンジっぽい文字列（`"1-3,5,7"`）を相互変換する Ruby gem。Ruby の Refinements パターンで `Array#to_s` と `String#to_a` を拡張している。

## Commands

```bash
# テスト実行（デフォルトタスク）
rake test

# 依存関係インストール
bin/setup

# 対話コンソール
bin/console

# gem ビルド＆リリース
bundle exec rake release
```

## Architecture

- **Refinements ベース**: `using RangePpoiString` で有効化。グローバル汚染なし
- `lib/range_ppoi_string.rb`: `Array#to_s`（配列→レンジ文字列）と `String#to_a`（レンジ文字列→配列）の2つの refine
- `.next` に応答するオブジェクト（Integer, String の各文字など）で動作する
- `SortedSet` を使って重複排除＆ソート後に連続要素をグルーピング
- テストフレームワーク: test-unit（`data` マクロによるパラメタライズドテスト）
