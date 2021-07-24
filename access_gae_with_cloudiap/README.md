# Access GAE with Cloud IAP

`main.yaml`

デイリーで実行するGAE(Backend)での処理があり、その一連の処理を実行するワークフロー。
* Cloud Schedulerで、毎日0時を回ったごろ起動
* EntryPointは１つしかなく、パラメータ等も不要でGETで呼び出すとすると、必要な処理がされて、応答文字列が帰ってくる。
* 応答文字列「all_proc_finished」が帰ってくるまで、繰り返し呼び出す（並列処理はできない）。
* おおよそ400回、3時間くらい呼び出し続けると、最後に「all_proc_finished」が帰ってきて、その日の処理は終了。
* 応答文字列「ERR」が帰って来たときは、何かしらのエラーなので、記録して、Workflowsは終了する。

***

CloudIAP認証をしたGAEでは、そのままWorkflowsから呼び出せなかったので、
* Cloud Workflowsから認証付きのGCF(Google Cloud Functions)やCloud Runを呼び出す方法は、以下に記載されている。
* https://cloud.google.com/workflows/docs/authentication#auth-requests-run-functions
* authセクションに`type: OIDC`として設定すると、Workflowsを実行しているサービスアカウントでGCF/CloudRunの認証をする(当該サービスアカウントに、呼び出せるよう許可する必要がある)。
```
auth:
  type: OIDC
```

* GAE(Google App Engine)では、Cloud IAPにアクセスを認めるgoogleアカウント等を設定することで、GAEに届く前にgoogle認証をやってくれるが、このような簡単な方法では認証できなかったので、Tokenを取得して、外部APIと同じ方法で認証を通過させる必要がある。
* https://cloud.google.com/workflows/docs/authentication#making_authenticated_requests_to_external_apis
* Tokenを取得して返すだけのGCFを作成（同じサービスアカウントで実行する）
* Tokenは（多分）1時間有効なので、3000秒後をExpire Timeとして保持し、使うときにExpireしていたら、もう一度GCFを呼び出してリフレッシュする（回数やインターバル次第では、GAE/IAPを呼び出すごとにGCFでtoken取得してもいいかもしれない。）。今の所、3000秒の設定で問題なく動いている。