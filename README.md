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
