# [使い方]
# make <プロジェクト名>
# 	→ source/project/<プロジェクト名>/main/main.tex がコンパイルされる
# make <プロジェクト名>-<サブプロジェクト名>
# 	→ source/project/<プロジェクト名>/<サブプロジェクト名>/main.tex がコンパイルされる

.PHONY: $(PROJECTS) $(SUB_PROJECTS)

# サブプロジェクトを検索してそのリストを返す関数
# ただし1文字目が_の場合は除外
find_sub_projects = $(wildcard source/project/$1/[^_]*)
# def find_sub_projects($1):
# 	return [source/project/$1/*]
# Ex. find_sub_projects(_sample_project)
# 	→ ["source/project/_sample_project/main", "source/project/_sample_project/sub"]

# 全プロジェクトのリスト
PROJECTS := $(foreach dir,$(wildcard source/project/*),$(notdir $(dir)))
# PROJECTS = [
# 	notdir(dir)
# 	for dir in [source/project/*]
# ]
# Ex. PROJECTS → ["_sample_project", "01_logic"]

# 全サブプロジェクトのリスト
SUB_PROJECTS := $(foreach proj,$(PROJECTS),$(foreach dir,$(call find_sub_projects,$(proj)),$(proj)-$(notdir $(dir))))
# SUB_PROJECTS = [
# 	proj + "-" + notdir(dir)
# 	for proj in PROJECTS
# 	for dir in find_sub_projects(proj)
# ]
# Ex. SUB_PROJECTS → ["_sample_project-main", "_sample_project-sub", "01_logic-main"]

# 各プロジェクトのルール
$(PROJECTS):
	cd source/project/$@/main && \
	latexmk -norc -r .latexmkrc -lualatex main && \
	cd ../../../..

# 各サブプロジェクトのルール
$(SUB_PROJECTS):
	cd source/project/$(word 1,$(subst -, ,$@))/$(word 2,$(subst -, ,$@)) && \
	latexmk -norc -r .latexmkrc -lualatex main && \
	cd ../../../..
