# Access GAE with Cloud IAP

Cloud IAP認証をしたGAEを、Cloud Workflowsから呼び出すサンプル

## ファイル:
`main.yaml`

## 動作概要
デイリーで実行するGAE(Backend)（以下、Targetという）での処理があり、その一連の処理を実行するワークフローを作成した。
* Cloud Schedulerで、毎日0時を回ったごろ、ワークフローを起動。
* TargetのEntryPointは１つしかなく、パラメータ等も不要でGETで呼び出すとすると、必要な処理がされて、応答文字列が帰ってくる。
* Targetから応答文字列「all_proc_finished」が帰ってくるまで、繰り返し呼び出す（並列処理はできない。すなわち、Targetを呼び出したら、）。
* おおよそ400回、3時間くらいTargetを呼び出し続けると、最後に「all_proc_finished」が帰ってきて、その日の処理は終了。
* 応答文字列「ERR」が帰って来たときは、何かしらのエラーなので、記録して、ワークフローは終了する。

## 認証付きGCF/Cloud Runを呼び出す方法
* Cloud Workflowsから認証付きのGCF(Google Cloud Functions)やCloud Runを呼び出す方法は、以下に記載されている。
* https://cloud.google.com/workflows/docs/authentication#auth-requests-run-functions
* authセクションに`type: OIDC`として設定すると、Workflowsを実行しているサービスアカウントでGCF/CloudRunの認証をする(当該サービスアカウントに、呼び出せるよう許可する必要がある)。
```
auth:
  type: OIDC
```

## Cloud IAP認証付きGAEを呼び出す方法
* GAE(Google App Engine)では、Cloud IAPにアクセスを認めるgoogleアカウント等を設定することで、GAEに届く前にgoogle認証をやってくれるが、GCF/Cloud RunのようにAuthセクションを設定するだけでは認証できなかった。何らかの方法でTokenを取得して、外部APIと同じ方法(HTTPヘッダにTokenをつける)で認証を通過させる必要がある。
* https://cloud.google.com/workflows/docs/authentication#making_authenticated_requests_to_external_apis
* そのために、Tokenを取得して返すだけのGCFを作成（同じサービスアカウントで実行する）する。ソースコードはfunctionsフォルダ内。ワークフローがus-central1で実行されるので、この関数もus-central1に作成した。
* Tokenは（多分）1時間有効なので、3000秒後をExpire Timeとして保持し、使うときにExpireしていたら、もう一度GCFを呼び出してリフレッシュする。今の所、3000秒の設定で問題なく動いている。外部関数を何度も呼び出すのはどうかと思い今の構成にしているが、有効期限を管理するのもステップ数を消費するので、GAE/IAPを呼び出すごとにGCFでToken取得してもいいかもしれない。


## 課金について
* 以下の課金に関するページでは、Google Cloud内部の例としてGAEは明記されていない。
* https://cloud.google.com/workflows/pricing?hl=ja#internal_and_external_steps
* 課金ページを見ると、WorkflowsはすべてInternal Stepsの課金になっており、External Stepsの課金は0(項目がない)。
* したがって、GAEへの呼び出しも、Internal Stepsの課金で処理されているといえる。
* なお、カスタムドメインを使用した場合は、External Stepsとして処理されると明記されている。