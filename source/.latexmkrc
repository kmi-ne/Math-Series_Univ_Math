use Cwd;
use File::Basename;

# 下位プロジェクト名（カレントディレクトリ名）を取得
my $curr_path = getcwd();
my $subproject_name = basename($curr_path);

# プロジェクト名（親ディレクトリ名）を取得
my $parent_path = dirname($curr_path);
my $project_name = basename($parent_path);

# pdf を命名
# 下位プロジェクト名が main の場合は接尾辞を省略
if ($subproject_name eq 'main') {
    $jobname = "series_univ_math-${project_name}";
} else {
    $jobname = "series_univ_math-${project_name}-${subproject_name}";
}

# main.tex からルートディレクトリへの相対パス
my $root_dir = '../../../..';

# 出力ディレクトリ
$out_dir = "${root_dir}/pdf/${project_name}";

# エンジン
$lualatex = 'lualatex %O -halt-on-error -file-line-error %S';
$xelatex = 'xelatex %O -halt-on-error -file-line-error %S';

# 索引
$makeindex = 'upmendex -s jpbase -l %O -o %D %S';
