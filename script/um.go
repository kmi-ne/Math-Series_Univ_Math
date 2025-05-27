// `./um init <プロジェクト名>`:
// 1. カレントディレクトリを `source/project` に移動
// 2. その中にある `_template` フォルダをコピーし，`<新規プロジェクト名>` にリネーム

// `./um make <プロジェクト名>`:
// 1. `source/project/<プロジェクト名>/main` に移動
// 2. `latexmk -norc -r .latexmkrc -lualatex main` を実行

// `./um make <プロジェクト名>-<サブプロジェクト名>`:
// 1. `source/project/<プロジェクト名>/<サブプロジェクト名>` に移動
// 2. `latexmk -norc -r .latexmkrc -lualatex main` を実行

// `./um makeall`:
// 全てのプロジェクト `<プロジェクト名>` に対し，次を行う．ただし，`<プロジェクト名>` が `_` から始まる場合は除外する．
// 1. `source/project/<プロジェクト名>/main` に移動
// 2. `latexmk -norc -r .latexmkrc -lualatex main` を実行

package main

import (
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

const basePath = "source/project"

func main() {
	if len(os.Args) < 2 {
		fmt.Println("使い方: um [init|make|makeall] [...args]")
		return
	}

	switch os.Args[1] {
	case "init":
		if len(os.Args) != 3 {
			fmt.Println("使い方: um init <プロジェクト名>")
			return
		}
		initProject(os.Args[2])
	case "make":
		engine := "lualatex"
		argIndex := 2

		if len(os.Args) >= 3 {
			if os.Args[2] == "-xe" {
				engine = "xelatex"
				argIndex = 3
			} else if os.Args[2] == "-lua" {
				engine = "lualatex"
				argIndex = 3
			}
		}

		if len(os.Args) <= argIndex {
			fmt.Println("使い方: um make [-lua|-xe] <プロジェクト名>")
			return
		}
		makeProject(os.Args[argIndex], engine)

	case "makeall":
		engine := "lualatex"
		if len(os.Args) >= 3 {
			if os.Args[2] == "-xe" {
				engine = "xelatex"
			} else if os.Args[2] == "-lua" {
				engine = "lualatex"
			}
		}
		makeAll(engine)

	default:
		fmt.Println("不明なコマンド:", os.Args[1])
	}
}

func initProject(projectName string) {
	src := filepath.Join(basePath, "_template")
	dst := filepath.Join(basePath, projectName)

	err := copyDir(src, dst)
	if err != nil {
		fmt.Println("プロジェクトの初期化に失敗:", err)
		return
	}
	fmt.Println("プロジェクトを初期化しました:", dst)
}

func makeProject(name, engine string) {
	var path string
	if strings.Contains(name, "-") {
		parts := strings.SplitN(name, "-", 2)
		if len(parts) != 2 {
			fmt.Println("無効なサブプロジェクト名")
			return
		}
		path = filepath.Join(basePath, parts[0], parts[1])
	} else {
		path = filepath.Join(basePath, name, "main")
	}

	if err := runLatexMk(path, engine); err != nil {
		fmt.Println("ビルド失敗:", err)
	}
}

func makeAll(engine string) {
	entries, err := os.ReadDir(basePath)
	if err != nil {
		fmt.Println("ディレクトリの読み込みに失敗:", err)
		return
	}

	for _, entry := range entries {
		if entry.IsDir() && !strings.HasPrefix(entry.Name(), "_") {
			path := filepath.Join(basePath, entry.Name(), "main")
			if _, err := os.Stat(filepath.Join(path, "main.tex")); err == nil {
				fmt.Println("ビルド中:", path)
				if err := runLatexMk(path, engine); err != nil {
					fmt.Println("ビルド失敗:", err)
				}
			}
		}
	}
}

func runLatexMk(dir, engine string) error {
	cmd := exec.Command("latexmk", "-norc", "-r", ".latexmkrc", "-"+engine, "main")
	cmd.Dir = dir
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

func copyDir(src string, dst string) error {
	return filepath.Walk(src, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		relPath, err := filepath.Rel(src, path)
		if err != nil {
			return err
		}
		destPath := filepath.Join(dst, relPath)

		if info.IsDir() {
			return os.MkdirAll(destPath, info.Mode())
		}

		return copyFile(path, destPath)
	})
}

func copyFile(src, dst string) error {
	srcFile, err := os.Open(src)
	if err != nil {
		return err
	}
	defer srcFile.Close()

	if err := os.MkdirAll(filepath.Dir(dst), 0755); err != nil {
		return err
	}

	dstFile, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer dstFile.Close()

	_, err = io.Copy(dstFile, srcFile)
	return err
}
