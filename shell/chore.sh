#!/bin/bash

## _から始めるメソッドは実行者には公開しない
_fvm() {
  fvm "$@"
}

_flutter() {
  _fvm flutter "$@"
}

_dart() {
  _fvm dart "$@"
}

## 実行者に公開する関数群
version() {
  _flutter --version
}

pub_get() {
  _flutter pub get
}

doctor() {
  _flutter doctor
}

analyze() {
  _flutter analyze --fatal-warnings
}

format() {
  _dart format ./lib ./test
}

build_runner() {
  _flutter pub run build_runner build --delete-conflicting-outputs
}

boot_strap() {
  pub_get
  build_runner
}

git_branch_delete() {
  echo "Please input initial branch name"
  read branch_name
  matching_branches=$(git branch | grep "$branch_name")

  if [ -z "$matching_branches" ]; then
    echo "No branches found with the name $branch_name"
    return
  fi

  # 該当するブランチ名を出力
  echo "Found branches:"
  echo "$matching_branches"

  # ユーザに削除の確認を取る
  echo "Do you really want to delete these branches? [y/N]"
  read confirmation

  if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
    # ブランチを削除
    git branch | grep "$matching_branches" | xargs git branch -d
  else
    echo "Aborted."
  fi
}

flutter_test() {
  fvm flutter test --coverage
  ## main.dartを除外
  lcov --remove coverage/lcov.info 'lib/main.dart' -o coverage/lcov.info
  genhtml coverage/lcov.info -o coverage/html
}


## CIに使うコマンドは選択肢には表示させない
_format_ci() {
  _dart format ./lib ./test -o none --set-exit-if-changed
}

# このスクリプト内で定義されている関数のうち、_で始まる関数、自身とmainを除いた関数名を表示する
_list_functions() {
  declare -F | awk '{print $3}' | grep -v "^_"
}

 # コマンドライン引数による分岐
function_name="$1"

if declare -f "$function_name" > /dev/null; then
  # 関数が存在する場合
  $function_name
else
  # 関数が存在しない場合（デフォルトの処理）
  # _で始まる関数、_list_functionsとmainを除いた関数名を配列に格納
  func_array=($(_list_functions))

  echo "Please select a function to execute:"
  select user_function in "${func_array[@]}"; do
    if [ -n "$user_function" ]; then
      $user_function
      break
    else
      # 数字でない場合は入力を関数名として扱う
      if declare -f "$REPLY" > /dev/null; then
        $REPLY
        break
      else
        echo "Invalid choice. Please try again."
      fi
    fi
  done
fi



