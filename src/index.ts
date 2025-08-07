import express from 'express'
import {  getWordsByNumber } from './queryHelpers'

const app = express()
const port = process.env.PORT ?? 5000

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy', timestamp: new Date().toISOString() })
})

app.get('/v1/words/number/:number', async (req, res) => {
  const words = await getWordsByNumber(req.params.number)
  res.json(words)
})



app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`)
})