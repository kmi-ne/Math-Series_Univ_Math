# Math-Series_Univ_Math

「シリーズ 大学の数学」は，学部～大学院初年度レベルの数学教科書シリーズおよびその執筆プロジェクトであり，自己完結性・網羅性・厳密性・一貫性を備えたオープンな教科書の実現を目指しています．

## ディレクトリ構造

`<>` で囲まれている部分は，適当な文字列が入るプレースホルダです．

```
📦Math-Series_Univ_Math
 ┣ 📂.vscode
 ┣ 📂pdf
 ┃ ┣ 📂<プロジェクトA>
 ┃ ┃ ┣ 📜series_univ_math-<プロジェクトA>.pdf ................... メイン文書
 ┃ ┃ ┣ 📜series_univ_math-<プロジェクトA>-<サブプロジェクトa>.pdf .... 補助文書
 ┃ ┃ ┗ 📜...
 ┃ ┣ 📂<プロジェクトB>
 ┃ ┗ 📂...
 ┣ 📂source
 ┃ ┣ 📂package
 ┃ ┃ ┣ 📂um
 ┃ ┃ ┣ 📂um_<パッケージ1>
 ┃ ┃ ┣ 📂um_<パッケージ2>
 ┃ ┃ ┗ 📂...
 ┃ ┣ 📂project
 ┃ ┃ ┣ 📂<プロジェクトA>
 ┃ ┃ ┣ 📂<プロジェクトB>
 ┃ ┃ ┗ 📂...
 ┃ ┗ 📜.latexmkrc
 ┣ 📜.gitattributes
 ┣ 📜.gitignore
 ┣ 📜LICENSE.md
 ┣ 📜Makefile
 ┗ 📜README.md
```

各プロジェクトは，**main プロジェクト**とそれ以外の**サブプロジェクト**からなります．

プロジェクト毎のディレクトリ構造は以下の通りです．

```
📦<プロジェクトA>
 ┣ 📂_package_local
 ┃ ┣ 📜um_patch.sty
 ┃ ┣ 📜<パッケージ1>.sty
 ┃ ┗ 📜...
 ┣ 📂main
 ┃ ┣ 📂bib
 ┃ ┣ 📂chapter
 ┃ ┃ ┣ 📂<チャプターX>
 ┃ ┃ ┃ ┣ 📂figure
 ┃ ┃ ┃ ┣ 📜_index.tex
 ┃ ┃ ┃ ┣ 📜<セクションx>.tex
 ┃ ┃ ┃ ┣ 📜<セクションy>.tex
 ┃ ┃ ┃ ┗ 📜...
 ┃ ┃ ┣ 📂<チャプターY>
 ┃ ┃ ┗ 📂...
 ┃ ┣ 📜.latexmkrc
 ┃ ┗ 📜main.tex
 ┣ 📂<サブプロジェクトa>
 ┣ 📂<サブプロジェクトb>
 ┗ 📂...
```
