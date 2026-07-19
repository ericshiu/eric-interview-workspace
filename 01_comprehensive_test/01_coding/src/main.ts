import fs from 'node:fs';
import readline from 'node:readline';

export async function findMostFrequentWordOptimized(filePath: string): Promise<void> {
  let maxCount = 0;
  let maxWord = '';
  // 紀錄每個單字出現次數的 Hash Map
  const wordCount: Record<string, number> = {};

  // 建立讀取檔案的串流介面
  const rl = readline.createInterface({
    input: fs.createReadStream(filePath),
    // 辨識所有作業系統的換行符號 (CRLF 或 LF)
    crlfDelay: Infinity, 
  });

  // 使用非同步迭代逐行讀取檔案 (不會一次把整個檔案塞進記憶體)
  for await (const line of rl) {
    // 將該行轉為小寫，並用正則表達式抓取所有英文字母/數字組成的單字
    // (如果你的 txt 檔案每行只有一個單字，可以改成 const word = line.trim();)
    const words = line.toLowerCase().match(/\b\w+\b/g) || [];

    for (const word of words) {
      // 計算單字出現次數
      wordCount[word] = (wordCount[word] || 0) + 1;

      // 即時更新最大值 (Time Complexity for this check is O(1))
      if (wordCount[word] > maxCount) {
        maxCount = wordCount[word];
        maxWord = word;
      }
    }
  }

  // 檔案讀取完畢，迴圈結束後判斷是否有找到單字
  if (maxCount === 0) {
    console.info('No words found.');
  } else {
    console.info(`${maxCount} ${maxWord}`);
  }
}