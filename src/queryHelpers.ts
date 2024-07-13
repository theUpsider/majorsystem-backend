import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export async function getWordsByNumber(number: string) {
  return prisma.word.findMany({
    where: {
      number: number,
    },
  })
}
