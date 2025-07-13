# Progate AWS Infrastructure
インフラ管理用のリポジトリです。

## Terraform Files

```
    ├── alb.tf # Application Load Balancer設定 - 内部ALB、Blue/Greenターゲットグループ、HTTPSリスナー
    ├── certificate.tf # ACM SSL証明書設定 - CloudflareでのDNS検証、ワイルドカード証明書対応
    ├── cloudflare.tf # Cloudflare DNS設定 - ALB用CNAMEレコード、ドメイン管理
    ├── cloudfront.tf # CloudFront CDN設定 - S3とALBの2つのオリジン、グローバル配信
    ├── codepipe.tf # CI/CDパイプライン設定 - GitHub連携、CodeBuild、CodeDeploy、Blue/Greenデプロイ
    ├── cognito.tf # Cognito認証設定 - ユーザープール、Google OAuth、ホストUI
    ├── data.tf # データソース定義 - AWS情報取得、IAMポリシー文書
    ├── ecs.tf # ECS Fargate設定 - クラスター、タスク定義、サービス、ECRリポジトリ
    ├── locals.tf # ローカル値定義 - プロジェクト名、AZ設定、サブネット設定
    ├── main.tf # メインリソース
    ├── network.tf # ネットワーク設定 - VPC、サブネット、ルートテーブル、NAT Gateway
    ├── outputs.tf # 出力値定義 - 各リソースのARN、ID、URL等の情報出力
    ├── provider.tf # プロバイダー設定 - AWS、Cloudflareプロバイダー設定
    ├── security.tf # セキュリティグループ設定 - ALB、バックエンド用のセキュリティグループ
    ├── variables.tf # 変数定義 - ドメイン名、API トークン、環境変数等
    └── versions.tf # プロバイダーバージョン設定 - 各プロバイダーのバージョン制約
```

## Usage

### Step.1
terraform.tfvars.exampleをコピー
```bash
cp terraform.tfvars.example terraform.tfvars
```

### Step.2
terraformを初期化
```bash
terraform init
```

### Step.3
作成される予定のリソース確認
```bash
terraform plan
```

### Step.4
リソース作成
```bash
terraform apply
```

約15分~ほどかかります。

## Delete
```bash
terraform destroy
```
