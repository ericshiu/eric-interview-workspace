# 03_database_select

建立一個自動化的 MySQL 測試環境，用於練習並驗證 SQL 查詢邏輯，特別是針對處理「並列排名（Tied Rankings）」等複雜邊緣情況的查詢驗證。

## 專案結構
- `Dockerfile`: 定義 MySQL 8.0 環境，包含自動化權限設定與初始化腳本。
- `init.sql`: 資料表結構定義與初始測試資料。
- `query_second_place.sql`: 使用 `DENSE_RANK()` 實現的穩健查詢邏輯，找出排名第二的學生班級
- `README.md`: 專案說明文件。

## 快速啟動指南

### 1. 建置 Docker 映像檔
在專案根目錄下執行以下指令：
```bash
docker build -t mysql-student-db .
```

### 2. 啟動容器
```bash
docker run --name mysql-test-instance -d -p 3306:3306 mysql-student-db
```

### 3. 執行 SQL 查詢
```bash
docker exec -e MYSQL_PWD=password -i mysql-test-instance mysql -u root -h 127.0.0.1 -D student < query_second_place.sql
```

## 說明

傳統使用 LIMIT 1 OFFSET 1 在處理分數重複時會發生遺漏
採用 DENSE_RANK() 窗口函數，確保在面對同分情況時，系統能正確篩選出所有並列第二名的學生及其班級，提升 SQL 語句在實際業務場景中的可靠性。