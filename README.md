クラウドベンダー (Level 3 細分化),事前準備・要件設定 (Level 4: 認証情報と権限) 🔑,最終検出対象 (Level 5: クラウド特有のCI)
AWS(Amazon Web Services),1. 認証情報: IAMユーザー (Access Key ID & Secret) または IAMロール (MID ServerがAWS上にある場合はIAMロールの割り当てが最もセキュア)。2. 権限ポリシー: AWS管理ポリシーの ReadOnlyAccess を付与。3. マルチアカウント: 複数アカウント環境の場合、AssumeRole の設定が必要。,"EC2インスタンス, VPC, サブネット, EBSボリューム, S3バケット, RDS, ALB/ELB。"
Azure(Microsoft Azure),"1. 認証情報: サービスプリンシパル (App Registration)。Client ID, Tenant ID, Client Secret の3点セットが必要。2. 権限ポリシー: 対象のサブスクリプション(Subscription)または管理グループに対し、Reader (閲覧者) ロールを付与。","仮想マシン (VM), 仮想ネットワーク (VNet), リソースグループ, ストレージアカウント。"
GCP(Google Cloud),"1. 認証情報: サービスアカウントの JSONキーファイル (Project ID, Client Email, Private Keyが含まれるもの)。2. 権限ポリシー: Compute Viewer (閲覧者) 等のロールを付与。3. 事前作業: GCPコンソール側で Compute Engine API 等の各種APIを有効化しておくこと。","Compute Engine インスタンス, VPC Networks, Cloud Storage, Cloud SQL。"
OCI(Oracle Cloud),"1. 認証情報: OCI独自の4つの情報が必要 (User OCID, Tenancy OCID, Fingerprint, および PEM形式の秘密鍵)。2. 権限ポリシー: 対象のコンパートメント (Compartment) に対する読取権限ポリシーの作成。","OCI Compute, VCN (仮想クラウドネットワーク), ブロックボリューム, コンパートメント。"


云服务商 (Level 3 细分),手动准备与配置要求 (Level 4: 凭证与权限) 🔑,最终纳管的专有 CI (Level 5)
AWS(亚马逊云),1. 凭证要求：IAM User (Access Key ID & Secret) 或 IAM Role (如果 MID Server 也建在 AWS 里，推荐直接用 Role，最安全)。2. 权限策略：分配 AWS 托管的 ReadOnlyAccess 策略。3. 账号规划：若有多账号，需提供 Master Account 并在子账号配置 AssumeRole。,"EC2 实例, VPC, Subnet, EBS 卷, S3 存储桶, RDS 数据库, ALB 负载均衡器。"
Azure(微软云),"1. 凭证要求：App Registration (应用注册/服务主体)，需获取 Client ID, Tenant ID 和 Client Secret。2. 权限策略：在目标 Subscription (订阅) 或 Management Group (管理组) 级别，赋予 Reader (读取者) 角色。3. 网络要求：确保 MID Server 能访问 Azure API 终结点。","Virtual Machines, VNet, Resource Group, Storage Account, Azure SQL。"
GCP(谷歌云),"1. 凭证要求：Service Account (服务账号)，必须生成并下载 JSON 格式的密钥文件 (包含 Project ID, Client Email, Private Key)。2. 权限策略：分配 Compute Viewer 角色 (或全局 Viewer 角色)。3. 前提动作：必须在 GCP 控制台手动启用对应的 API (如 Compute Engine API)。","Compute Engine 实例, VPC Networks, Cloud Storage, Cloud SQL。"
OCI(甲骨文云),"1. 凭证要求：需要 4 个极其特殊的参数：User OCID, Tenancy OCID, Fingerprint, 以及 PEM 格式的私钥。2. 权限策略：在目标 Compartment (区间) 分配对应的 Read 策略。","OCI Compute, VCN (虚拟云网络), Block Storage, Compartments。"


コンピュート: Windows/Linux/Unixサーバ, ESXiホスト。

ネットワーク機器: ルーター, スイッチ。

セキュリティ・制御: ファイアウォール, ロードバランサ (F5等)。

ストレージ: SAN/NAS ストレージアレイ。

稼働中のソフトウェア: Webサーバ (IIS/Tomcat), データベース (Oracle/SQL Server)。

周辺機器: ネットワークプリンタ, UPS。
おはようございます。

昨日の議論を踏まえ、Linux MID ServerとWindows MID Serverの月額ランニングコストを比較しました。

なお、「1台のMID Serverで400台のACC」と記載されていますが、今回は4,000台の誤記として計算しています。

【計算条件】

・Azureリージョン：Japan East
・稼働時間：24時間365日（730時間/月）
・VMサイズ：Standard_B4ms
・CPU／メモリ：4 vCPU、16 GiB
・OSディスク：Standard SSD、32 GiB
・料金モデル：Pay-as-you-go
・対象ACC数：300,000台
・1台のMID ServerあたりのACC数：4,000台

【1台あたりの月額費用】

・Windows Server：約173.22 USD/月
・Red Hat Enterprise Linux：約203.59 USD/月
・差額：約30.37 USD/月（RHELの方が高い）

RHELの費用には、Red Hat Enterprise Linuxのソフトウェア料金が含まれています。

【必要なMID Server台数】

300,000台 ÷ 4,000台 = 75台

75台で計算した場合、月額の差額は以下のとおりです。

・Windows Server：約12,991.50 USD/月
・RHEL：約15,269.10 USD/月
・差額：約2,277.60 USD/月

【構成を選定した根拠】

・ServiceNow MID Server system requirements
ServiceNowにおけるMID Serverの基本的なシステム要件、対応OS、CPU、メモリなどを確認するための資料です。
https://www.servicenow.com/docs/r/servicenow-platform/mid-server/r_MIDServerSystemRequirements.html

・ServiceNow Agent Client Collector Installation
ACCの接続上限やMID Serverの処理 क्षमताを確認するための資料です。デフォルトでは1台のMID Serverあたり4,000台のACCが設定されており、8 GiBのJVM Heapで最大約8,000台のACCをサポートできると記載されています。
https://www.servicenow.com/docs/r/it-operations-management/agent-client-collector/acc-installation.html

・Microsoft Azure Standard B4ms specifications
Azure Standard_B4msのハードウェア仕様と性能特性を確認するための資料です。4 vCPU、16 GiBメモリ、CPUクレジットを利用するバースト型VMであることを確認できます。
https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/general-purpose/bv1-series

つまり、1つ目の資料でServiceNowが求めるMID Serverの要件を確認し、2つ目の資料でACC数とMID Serverの処理容量を確認し、3つ目の資料でAzure B4msのハードウェア仕様と性能特性を確認しています。

今回のStandard_B4msは、4 vCPU・16 GiBという条件で比較するための候補構成です。ServiceNowがAzure B4msを直接推奨しているわけではありません。また、B4msはバースト型VMのため、本番環境で使用する場合は、PoCでCPU使用率、CPUクレジット、メモリ使用率、JVM Heapおよび処理遅延を確認したうえで、最終的なVMサイズを決定する必要があります。

今回の金額はAzure Pricing Calculatorによる初期見積もりであり、バックアップ、監視、ネットワーク、冗長化、税金などの追加費用は含まれていません。
