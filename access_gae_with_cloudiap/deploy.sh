# デプロイ用スクリプト
# フォルダに関係しないフラグはdeploy_flags.yamlに書くこと


CLOUD_SERVICE="workflows"
# CLOUD_SERVICE="functions"

# shファイルのフォルダ取得　http://www.ajisaba.net/sh/get_dir.html
CURRENT=$(cd $(dirname $0);pwd)
# echo $CURRENT

# フォルダ名取得
DIR_NAME=`echo "$CURRENT" | sed -e 's/.*\/\([^\/]*\)$/\1/'`

# 名前
# 基本はフォルダ名=関数名
NAME=$DIR_NAME

# 入力する場合
# NAME="XXXXXXX"

# workflows
gcloud $CLOUD_SERVICE deploy $NAME \
  --source $CURRENT/main.yaml \
  --flags-file ${CURRENT}/deploy_flags.yaml

# functions
# gcloud $CLOUD_SERVICE deploy $NAME \
#   --source $CURRENT/main.yaml \
#   --flags-file ${CURRENT}/deploy_flags.yaml
