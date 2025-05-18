# [使い方]
# make <プロジェクト名>
# 	→ source/project/<プロジェクト名>/main/main.tex がコンパイルされる
# make <プロジェクト名>-<サブプロジェクト名>
# 	→ source/project/<プロジェクト名>/<サブプロジェクト名>/main.tex がコンパイルされる

.PHONY: $(PROJECTS) $(SUB_PROJECTS)

# プロジェクト内のサブプロジェクトを検索して，ルートからのパスのリストを返す関数
# 1文字目が_の場合はサブプロジェクトではないとし，除外する
# $1: プロジェクト名
find_sub_projects = $(wildcard source/project/$1/[^_]*)
# Ex. $(call find_sub_projects _sample_project)
# 	→ source/project/_sample_project/main source/project/_sample_project/sub

# 全プロジェクトのリスト
PROJECTS := $(foreach dir,$(wildcard source/project/*),$(notdir $(dir)))
# Ex. $PROJECTS
# 	→ _sample_project 01_logic

# 全サブプロジェクトのリスト
SUB_PROJECTS := $(foreach proj,$(PROJECTS),$(foreach dir,$(call find_sub_projects,$(proj)),$(proj)-$(notdir $(dir))))
# Ex. $SUB_PROJECTS
# 	→ _sample_project-main _sample_project-sub 01_logic-main

# 各プロジェクトのルール
$(PROJECTS):
	cd source/project/$@/main && \
	latexmk -norc -r .latexmkrc -lualatex main && \
	cd ../../../..

# 各サブプロジェクトのルール
# $@ = <プロジェクト名>-<サブプロジェクト名> のハイフンをスペースに置き換え，2語に分離してパスにする
$(SUB_PROJECTS):
	cd source/project/$(word 1,$(subst -, ,$@))/$(word 2,$(subst -, ,$@)) && \
	latexmk -norc -r .latexmkrc -lualatex main && \
	cd ../../../..
