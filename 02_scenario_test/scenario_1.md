# Ｑ：試想臨時有一活動網頁專案將於近日推出,預期推廣期間訪客流量會是平日常態之百倍


## 系統層面

### 1. 「快取擊穿」與「雪崩」：Nginx/CDN 的進階設定
- 全面使用 CDN： 將網頁的靜態資源（HTML、CSS、JavaScript、圖片、影片）全部上傳至 CDN（如 Cloudflare、AWS CloudFront）。
- 前端透過非同步（AJAX/Fetch）方式呼叫 API
- 透過在 Nginx 或 CDN 設定 stale-while-revalidate，系統只會放行「一個」背景請求去後端更新資料，其他的百萬個請求會繼續拿到稍微過期（Stale）的舊資料。這能完美防止源站瞬間被打穿。
- Token ， API Gateway 利用腳本，直接在最外層驗證 JWT Token 或阻擋惡意 IP。
### 2.  資料庫：連線池與鎖
- 中介層 ProxySQL
- 預先載入 Redis，利用 Redis 單執行緒的特性，憶體中成功後，才允許後續流程繼續
- 縮短持鎖時間，放鎖的速度越快，DB 的吞吐量才上得去
- 關閉重試機制，失敗就直接在前端回傳
- 冪等性
- 數據庫 Timeout
- 分表
### 3. 非同步解耦(Q)：Broker 與 Worker 容器的吞吐控制
- Message Broker ： Web API 收到請求後，只做最基本的格式驗證，接著把使用者的行為打包成 JSON Payload，直接丟進 Message Broker（例如 Kafka 或 RabbitMQ；

- 專職 Worker 批次寫入： 後端另外啟動一組專門負責消化 Queue 的 Worker 容器。

## 監控

### 1. SLI / SLO
- SLI： 定義針對活動網頁，核心 API 的延遲時間，正確率。

- SLO： 目標設立多少 ％ 的 API 請求必須在 100ms 內回應，成為 Infar擴容的 Base Line.
### 2. Observability
- （Latency）、（Traffic）、（Errors）、（如 DB Connection）
### 3. MTTR
- 自動化與流程設計，取代人工的排查，提高恢復速度，自動故障轉移