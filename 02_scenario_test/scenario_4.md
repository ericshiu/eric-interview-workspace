# Q:進行線上錯誤排查,你/妳會如何將日誌檔內容串接至 ELK/EFK 系統?考量的細節是什麼?

## Log Generation & Collection
1. 格式 Structured Logging
2. 服務特性 VM、Bare Metal、Docker、Kubernetes、stdout
3. Agent （容器化環境、stdout/stderr）
   1. 這部分就很廣泛，如果是雲服務幾乎不用開採，就已被集成，如需要開採就需要考慮Resource Limits、Log Rotation避免重複採集

## Buffering & Decoupling
永遠不要讓 Agent 直接把大量資料直灌 Elasticsearch ， 我曾經處理過每秒100k+的github log，高峰期永遠比預估還高，所以需要平滑曲線消耗

1. 導入 Message Queue (如 Kafka 或 Redis)：
   1. 在 Filebeat/Fluentd 與 Logstash 之間加入 Kafka 作為緩衝池（Buffer）。
   2. 削峰填谷： 當新服務發生異常爆量日誌時，資料會先堆積在 Kafka 裡。
   3. Topic 規劃： 新服務必須有獨立的 Topic 之外，可以平估日誌重要程度去區分，還有時效性，以及貴公司的消耗速率來規劃topic ， 並非每個服務就一個 topic

## Parsing & Enrichment
1. 上下文綁定 (Context Enrichment)：Trace ID
2. 是否有 PII、密碼、Token(Data Masking)
3. 無效資料丟棄 (Drop/Filter)

## Storage & Index Lifecycle
1. Index Template & Mapping : 
   1. 關閉動態映射 (Dynamic Mapping) 的濫用：這會導致集群記憶體崩潰，或是設置index Field
   2. 明確區分 Field（text需要全文檢索） 與 （keyword精確數值），避免後期慢查詢導致ＥＳ崩潰
2. ILM - Index Lifecycle Management / Data Streams：
   1. Index 名稱設計時就可以規劃好生命週期
   2. 按照日置量決定按天建立index還是周，切氛圍50GB最好

## RBAC & TLS

## Visualization & Alerting