# デプロイ用スクリプト
# フォルダに関係しないフラグはdeploy_flags.yamlに書くこと


# CLOUD_SERVICE="workflows"
CLOUD_SERVICE="functions"

# shファイルのフォルダ取得
CURRENT=$(cd $(dirname $0);pwd)
# echo $CURRENT

# 名前
NAME="get_token"

# workflows
# gcloud $CLOUD_SERVICE deploy $NAME \
#   --source $CURRENT/main.yaml \
#   --flags-file ${CURRENT}/deploy_flags.yaml

# functions
gcloud $CLOUD_SERVICE deploy $NAME \
  --source $CURRENT \
  --flags-file ${CURRENT}/deploy_flags.yaml
