import { PrismaClient } from '@prisma/client'
import fs from 'fs'
import csv from 'csv-parser'

const prisma = new PrismaClient()

interface CsvRow {
  word: string;
  number: string;
}

async function main() {
  const results: CsvRow[] = []

  await new Promise<void>((resolve, reject) => {
    fs.createReadStream('major_system_data.csv')
      .pipe(csv())
      .on('data', (data: CsvRow) => results.push(data))
      .on('end', () => resolve())
      .on('error', (error) => reject(error))
  })

  const uniqueWords = new Set<string>();
  const uniqueResults = results.filter(row => {
    if (!uniqueWords.has(row.word)) {
      uniqueWords.add(row.word);
      return true;
    }
    return false;
  });

  const batchSize = 100000; // Adjust this based on your needs
  let inserted = 0;

  for (let i = 0; i < uniqueResults.length; i += batchSize) {
    const batch = uniqueResults.slice(i, i + batchSize);
    await prisma.word.createMany({
      data: batch,
    });
    inserted += batch.length;
    console.log(`Inserted ${inserted} words so far...`);
  }

  console.log(`Database populated successfully with ${inserted} unique words`);
  await prisma.$disconnect();
}

main().catch((e) => {
  console.error(e)
  process.exit(1)
})