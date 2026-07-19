# Ｑ：試想有一個 API 伺服器集群,背後由多台機器組成,此時服務監控系統發現其中一台回應時間



### 第一階段：緊急止血與隔離 (Isolation)

其中一台，代表還有多台可用，立刻在負載平衡器（如 Nginx、AWS ALB）上將該異常節點標記為 Offline 或 Drain 狀態，停止將新流量導入該機器。

### 第二階段：作業系統與硬體層面排查 (Hardware)

檢查基礎資源的利用率與健康狀態，實際經驗大多問題會發生在這
- CPU 使用率是否持續過高
- Memory 是否不足或發生 OOM
- Disk I/O 是否飽和
- Network 是否有大量重傳或頻寬不足
- GC（Java）、Process Hang 或 Thread Pool 滿載等情況

### 第三階段：應用程式與網路層面排查 (Application & Network)

- 分析 Application Log (ELK 重要指標)
- 網路連線狀態 (netstat, ss)

### 第四階段：依賴服務
- Database Connection Pool 耗盡
- Cache（Redis）連線異常
- MQ（Kafka、RabbitMQ）連線問題
- DNS 解析異常

### 第五階段：Root Cause Analysis
- 排查過程中盡量降低對線上服務的影響，並保留相關 Log 與監控資料，後續 RCA 分析。