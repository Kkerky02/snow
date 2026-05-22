三、 コアディスカバリメカニズムの深掘り
1. 水平ディスカバリ（Horizontal Discovery）— 基礎コンポーネント基盤
水平ディスカバリの役割は「網羅的なスキャン」であり、ネットワーク内に「何が存在するか」を特定する
ことです。ビジネスコンテキストを持たず、対象デバイスが応答すれば、標準的な構成アイテム（CI:
Configuration Item）としてCMDBに登録します。主なデータ収集パイプラインは以下の通りです：
Network Discovery： MID ServerからWMI、SSH、SNMPプロトコルを使用し、指定されたIPレンジを
スキャンします。物理サーバ、ルータ、OSの詳細情報、および稼働中のプロセス情報を取得します。
【第3層：リレーションシップ構築】垂直ビジネスサービスマッピング層 (Service
Mapping)
 Tag-Based Discovery (論理的グループ
化)
パブリッククラウドの標準タグ(Tag)キーペアを読み
取り、ネットワーク権限なしで迅速に境界を定義。
 Top-Down Pattern Discovery (技術的深
掘り)
エントリポイントからのTCP接続や設定ファイル解
析を通じて、プロセス・アプリケーション層の依存
関係を可視化。
【第2層：アセットデータ収集】水平ディスカバリ層 (Horizontal Discovery)
 Cloud /
Serverless
クラウドAPI
連携による
VMおよび
PaaSリソー
スの取得
Network
(IPレンジ)
MID Server
経由でのオ
ンプレミス
スイッチや
OSのエー
ジェントレ
ススキャン
 Agent
Client
Collector
エンドポイン
トへのエー
ジェント導入
によるリモー
ト端末管理
 K8s /
Container
API Server連
携による動的
Pod・コンテ
ナ血統の追跡
 EASM
(アタック
サーフェス)
外部インター
ネット視点で
の未承認公開
アセットの検
知
 Service
Graph
サードパー
ティ製品
(SCCM等)から
の構成アイテ
ム(CI)自動取
り込み
【第1層：インフラストラクチャ環境】 (Infrastructure Environments)
パブリッククラウド (Azure / AWS / GCP) • オンプレミス・データセンター • エンドユーザー・ネッ
トワーク • 外部インターネット公開領域
•
ServiceNow アーキテクチャ設計書 内部リファレンス資料 2
Cloud & Serverless Discovery： 認証情報を使用せず、クラウドベンダー（Azure, AWS等）のAPIに直
接接続します。仮想マシン（VM）だけでなく、サーバーレス機能（Lambda等）、コンテナ、PaaSデー
タベースをキャプチャし、クラウドの弾力性によるCIの追跡漏れを防ぎます。
Agent Client Collector (ACC)： リモートワーク用のノートPCなど、固定IPを持たないデバイスに対して
軽量エージェントを導入し、ネットワーク接続時にハードウェアおよびソフトウェア構成を自動報告させ
ます。
Kubernetes Container Discovery： K8s環境のAPI Serverと連携し、ライフサイクルの短いマイクロ
サービス（Cluster → Node → Namespace → Pod → Container）をリアルタイムにマッピングします。
EASM (外部アタックサーフェス管理)： ハッカーの視点からインターネット側より企業のIPレンジやドメ
インをスキャンし、IT部門の許可なく公開されたシャドーITリソースを検出します。
Service Graph Connectors： 既存の資産管理ツール（SCCM、Intune、Jamfなど）と連携する標準コネ
クタを利用し、サードパーティのデータをシームレスにCMDBへ統合します。
2. サービスマッピング（Service Mapping）— ビジネス依存関係の設計
水平ディスカバリがCMDBに「部品」を提供した後、サービスマッピングがそれらをビジネス価値を持つ
「アプリケーションサービス」へと組み立てます。マッピングには主に2つのアプローチがあります：
