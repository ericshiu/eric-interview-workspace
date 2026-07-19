# AsiaYo EKS 平台部署架構指南 (Infrastructure & Application)

Amazon EKS 叢集上，建構具備高可用性 (HA) 與跨可用區 (Multi-AZ) 容錯能力的網頁平台與資料庫架構。
部署流程涵蓋底層 AWS 資源控制器配置，以及上層資料庫與平台服務的 Helm 佈建。

## 系統架構總覽

*   **流量入口 (Ingress)**：透過 `aws-load-balancer-controller` 自動配置 AWS Application Load Balancer (ALB) 處理外部 HTTP/HTTPS 流量。
*   **平台服務 (Platform)**：無狀態應用程式，透過 Topology Spread Constraints 分佈於多個可用區 (Availability Zones)。
*   **資料庫服務 (Database)**：使用 Bitnami MySQL 建立 Primary (讀寫) / Secondary (唯讀) 複寫架構，並透過嚴格的 Pod Anti-Affinity 確保主要與備援資料庫部署於不同的 Node 

---

## 專案目錄結構

```text
.
├── terraform/               # 基礎設施配置 (EKS, IAM, ALB Controller)
├── database/                # 資料庫 Helm Chart 變數檔 (依賴 Bitnami MySQL)
│   ├── Chart.yaml
│   └── values.yaml          # 配置拓撲分佈約束
└── platform/                # 平台服務客製化 Helm Chart
    ├── Chart.yaml
    ├── values.yaml
    └── templates/
        ├── deployment.yaml  # 應用程式本體與跨可用區分佈設定
        ├── ingress.yaml     # AWS ALB Ingress 資源宣告
        ├── pvc.yaml         # EBS 儲存空間宣告
        └── service.yaml     # 叢集內部流量轉發
```

---

## 部署步驟
### 本地端基礎設施測試 (LocalStack)
為了在不產生 AWS 雲端費用的情況下驗證 Terraform 腳本，使用 LocalStack 進行本地端基礎設施模擬。

```
docker run --rm -it \
  -e LOCALSTACK_AUTH_TOKEN=$LOCALSTACK_AUTH_TOKEN \
  -p 4566:4566 \
  -p 4510-4559:4510-4559 \
  localstack/localstack


cd terraform/

# 初始化與部署本地端資源 (僅供練習，不會部署到真實 AWS)
tflocal init
tflocal plan
tflocal apply

```
