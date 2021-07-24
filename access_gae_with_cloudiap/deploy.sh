# デプロイ用スクリプト
# フォルダに関係しないフラグはdeploy_flags.yamlに書くこと


CLOUD_SERVICE="workflows"
# CLOUD_SERVICE="functions"

# shファイルのフォルダ取得　http://www.ajisaba.net/sh/get_dir.html
CURRENT=$(cd $(dirname $0);pwd)
# echo $CURRENT

# 名前
NAME="your_workflow_name"

# workflows
gcloud $CLOUD_SERVICE deploy $NAME \
  --source ${CURRENT}/main.yaml \
  --flags-file ${CURRENT}/deploy_flags.yaml

# functions
# gcloud $CLOUD_SERVICE deploy $NAME \
#   --source ${CURRENT}/main.yaml \
#   --flags-file ${CURRENT}/deploy_flags.yaml
