# Ｑ:試想有一項目運行於 AWS EC2 機器之上,已確認該服務仍然正常運行中,但由於不明原因導致無法再次透過 SSH 登入確認狀態(已確認排除並非網路異常,亦非防火牆阻擋所導致)。

既然已排除網路與 Security Group / NACL / 防火牆問題，且服務本身仍在運行，表示 instance 基本上是活著的，但 SSH daemon 或認證機制出了問題。

   
1. SSH 本身進程異常
   1. sshd 服務崩潰，異常停止
   2. sshd_config 被改錯
2. 權限或認證檔案被竄改
   1. Key 被換掉、刪除
   2. Cloud-init 覆蓋
   3. User?
3. loudWatch Metrics：查看 CPU、Memory、Disk Utilization、Network：
   1. Out of Memory Killer：當系統記憶體壓力過大時，我多次遇到ssm-agent被OOM killer終止的情況。要設置成OOMScoreAdjust
   2. Disk 100% full → SSH 無法寫入 log/auth files,sshd 可能會拒絕連線 
   3. 高 CPU load 會讓 SSH 連線 timeout

## 排查與恢復正常運作的步驟

1. 使用其他管理方式登入
   1. 若有啟用 AWS Systems Manager (SSM Session Manager)，我會優先透過 SSM 登入，而不是依賴 SSH。
   2. 透過 EC2 Serial Console 存取
2. 檢視 EC2 系統日誌
   1. AWS Console 查看是否有 Out of memory、No space left on device 或 sshd 錯誤的紀錄
3. EBS Volume 做 Snapshot （需停機）
   1. Snapshot ，關閉故障 EC2 ，開一個新的 ec2 卦仔這個 Snapshot，在新的 ec2 上修復
   2. 修復完畢後掛回原始 ec2
   

## 預防
1. SSM
2. 自動化備援機制
3. 定期 Snapshot + 建立 AMI
4. 關鍵服務放在 Auto Scaling Group + ALB，單一 EC2 故障時可快速替換