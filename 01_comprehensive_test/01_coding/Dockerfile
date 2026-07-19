# ==========================================
# Stage 1: Build (編譯階段)
# ==========================================
# 將原本的 node:20-alpine 改為 26
FROM node:26-alpine AS builder

# 設定工作目錄
WORKDIR /app

# 1. 先複製 package 設定檔，利用 Docker 快取機制加速 npm install
COPY package.json package-lock.json ./

# 安裝所有依賴（包含 devDependencies 如 typescript, @types/node 等）
RUN npm ci

# 2. 複製 TypeScript 設定檔與原始碼
COPY tsconfig.json ./
COPY src/ ./src/

# 3. 執行編譯（將 .ts 編譯為 .js，假設你的 tsconfig.json 將輸出目錄設定為 "outDir": "./dist"）
RUN npx tsc

# ==========================================
# Stage 2: Production (執行階段)
# ==========================================
# 同樣將這裡的執行環境也升級到 26
FROM node:26-alpine

# 設定工作目錄
WORKDIR /app

# 1. 複製 package 設定檔，只安裝正式環境需要的套件 (減少 Image 體積)
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# 2. 從編譯階段 (builder) 複製編譯好的 JavaScript 檔案
COPY --from=builder /app/dist ./dist

# 3. 複製演算法需要讀取的文本檔案
COPY words.txt ./

# 4. 指定容器啟動時執行的指令 (使用 Node.js 執行編譯後的入口檔案)
CMD ["node", "dist/main.js"]