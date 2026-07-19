# 目錄結構總覽
## 01_comprehensive_test/ (綜合應用測驗)
本模組涵蓋了系統開發的核心技術棧：

- 01_coding/: 包含 TypeScript 專案原始碼，應用了 Jest 進行單元測試

- 02_k8s_infra/: 基礎設施自動化配置：

  - k8s/: Kubernetes，定義應用服務與資料庫的部署資源。

  - terraform/: IaC 配置，利用模組化設計管理不同環境的部署。

- 03_database_select/: 資料庫實戰模組，包含環境初始化 (init.sql) 與複雜查詢優化範例，並透過 Dockerfile 實現容器化部署與隔離。

## 02_scenario_test/ (情境實戰測驗)
此目錄記錄了針對系統設計、故障排除與架構優化的情境分析筆記：

- scenario_1.md
- scenario_2.md
- scenario_3.md
- scenario_4.md

針對高併發、可靠性、架構瓶頸等實戰情境所進行的技術討論與解決方案規劃。