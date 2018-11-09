(2016.04.30)
--------------------------------------------------------------------------------
■実行方法などについて
--------------------------------------------------------------------------------

1. dockerはセットアップ済みで、各コマンドをsudoを使用せずに実行できるようになっていること

2. このディレクトリの内容をサーバーに置く		#cpの実行は試していない、対象の場所にコピー出来ればOK (2018.11.05)
$ cp -r /vagrant/nginx-php/ /home/vagrant/docker-user-server

3. 以下のシェルを実行(docker-composeを使用する形式に変更)
$ cd /home/vagrant/docker-user-server
$ ./start.sh

4. サービスを登録(VirtualBoxのファイル共有の初期化とdockerの起動タイミングがあるので、サービスを作成して対応している)
$ sudo cp docker-user-server.service /usr/lib/systemd/system
$ sudo systemctl enable docker-user-server
$ sudo systemctl start docker-user-server
