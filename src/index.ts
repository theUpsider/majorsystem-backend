import express from 'express'
import {  getWordsByNumber } from './queryHelpers'

const app = express()
const port = process.env.PORT ?? 5000

// CORS middleware
app.use((req, res, next) => {
  // Allow requests from your frontend domain
  res.header('Access-Control-Allow-Origin', 'https://davidfischer.dev')
  // Also allow localhost for development
  if (req.headers.origin === 'http://localhost:3000' || req.headers.origin === 'http://localhost:5173' || req.headers.origin === 'http://127.0.0.1:5173') {
    res.header('Access-Control-Allow-Origin', req.headers.origin)
  }
  
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization')
  res.header('Access-Control-Allow-Credentials', 'true')
  
  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    res.sendStatus(200)
    return
  }
  
  next()
})

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