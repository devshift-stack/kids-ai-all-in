import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { GoogleGenerativeAI } from '@google/generative-ai';
import { v4 as uuidv4 } from 'uuid';
import rateLimit from 'express-rate-limit';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Rate Limiting für API-Schutz
const apiLimiter = rateLimit({
  windowMs: 1 * 60 * 1000, // 1 Minute
  max: 100, // 100 Requests pro Minute
  message: 'Zu viele Anfragen, bitte später erneut versuchen.'
});

app.use('/api/', apiLimiter);

// Gemini API Setup
const GEMINI_API_KEY = process.env.GEMINI_API_KEY || '';
if (!GEMINI_API_KEY) {
  console.error('⚠️ GEMINI_API_KEY nicht gesetzt!');
  process.exit(1);
}

const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ 
  model: 'gemini-1.5-flash',
  generationConfig: {
    temperature: 0.8,
    topK: 40,
    topP: 0.95,
    maxOutputTokens: 512,
  },
  systemInstruction: getSystemPrompt(),
});

// Session Storage (In-Memory - für Production: Datenbank verwenden)
const sessions = new Map();

// System-Prompt für Lisa
function getSystemPrompt() {
  return `You are Lisa, the best sales agent in a call center specializing in selling solar panels (Solarmodule) over the phone. You are charming, empathetic, and professional – like a friendly expert who genuinely cares about helping the customer save money, improve their life, and solve problems.

**Your Personality and Style:**
- **Charming and Persistent but Not Pushy:** Be warm, engaging, and enthusiastic. Use compliments and positive language to build rapport (e.g., "That's a great question!"). Never give up easily if the customer shows interest, but respect "no" – suggest alternatives or follow up politely without overwhelming.
- **Keep It Simple:** Don't overload the customer with technical jargon or too much expert knowledge. Explain only what's important in simple terms (e.g., instead of detailed specs on solar panels, say: "This could cut your electricity bill by 30% and help the environment – sounds good, right?").
- **Lead with Questions:** Remember the rule: "Who asks, leads." Guide the conversation by asking open-ended questions to uncover the customer's goals, desires, emotions, and fears.
- **Build Trust and Emotional Connection:** Listen actively, reflect back what they say, and tie products to their personal story.
- **Sales Structure:** Follow this flow naturally:
  1. **Greeting and Rapport:** Start friendly, confirm identity, and ask how they're doing.
  2. **Qualify Needs:** Ask questions to understand their situation.
  3. **Present Value:** Highlight key benefits tailored to their answers.
  4. **Handle Objections:** Address fears empathetically.
  5. **Close Gently:** Ask for commitment with questions like "Would you like to get a free quote today and start saving?"
  6. **End Positively:** Thank them, even if no sale – offer follow-up.
- **Rules:** Stay ethical – no false promises. Keep responses concise (under 100 words per turn). End turns with a question to keep dialogue going. Always respond in the customer's language (German if they speak German, English if they speak English).`;
}

// API Routes

// Health Check
app.get('/api/v1/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    activeSessions: sessions.size,
    timestamp: new Date().toISOString()
  });
});

// Neue Session erstellen
app.post('/api/v1/sessions', (req, res) => {
  const sessionId = uuidv4();
  const chat = model.startChat();
  
  const session = {
    id: sessionId,
    chat: chat,
    messages: [],
    createdAt: new Date().toISOString(),
    lastActivity: new Date().toISOString(),
  };
  
  sessions.set(sessionId, session);
  
  // Begrüßung von Lisa
  const greeting = 'Hallo! Ich bin Lisa, Ihre Verkaufsberaterin. Schön, dass ich Sie erreiche! Wie geht es Ihnen heute? Ich rufe an, um über Solarmodule zu sprechen – haben Sie sich schon einmal Gedanken über Solarstrom gemacht?';
  
  session.messages.push({
    role: 'assistant',
    text: greeting,
    timestamp: new Date().toISOString(),
  });
  
  res.json({
    sessionId: sessionId,
    greeting: greeting,
    createdAt: session.createdAt,
  });
});

// Nachricht an Session senden
app.post('/api/v1/sessions/:sessionId/chat', async (req, res) => {
  const { sessionId } = req.params;
  const { message } = req.body;
  
  if (!message || typeof message !== 'string') {
    return res.status(400).json({ error: 'Message ist erforderlich' });
  }
  
  const session = sessions.get(sessionId);
  if (!session) {
    return res.status(404).json({ error: 'Session nicht gefunden' });
  }
  
  try {
    // User-Nachricht speichern
    session.messages.push({
      role: 'user',
      text: message,
      timestamp: new Date().toISOString(),
    });
    
    // Gemini API aufrufen
    const result = await session.chat.sendMessage(message);
    const response = result.response.text();
    
    // Assistant-Antwort speichern
    session.messages.push({
      role: 'assistant',
      text: response,
      timestamp: new Date().toISOString(),
    });
    
    session.lastActivity = new Date().toISOString();
    
    res.json({
      sessionId: sessionId,
      response: response,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Gemini API Error:', error);
    
    let errorMessage = 'Entschuldigung, es ist ein Fehler aufgetreten. Können Sie Ihre Frage bitte wiederholen?';
    
    if (error.message?.includes('quota') || error.message?.includes('429')) {
      errorMessage = 'Entschuldigung, ich habe momentan zu viele Anfragen. Bitte versuchen Sie es in ein paar Minuten erneut.';
    }
    
    res.status(500).json({
      error: errorMessage,
      sessionId: sessionId,
    });
  }
});

// Session-Status abrufen
app.get('/api/v1/sessions/:sessionId', (req, res) => {
  const { sessionId } = req.params;
  const session = sessions.get(sessionId);
  
  if (!session) {
    return res.status(404).json({ error: 'Session nicht gefunden' });
  }
  
  res.json({
    sessionId: session.id,
    messageCount: session.messages.length,
    createdAt: session.createdAt,
    lastActivity: session.lastActivity,
    messages: session.messages,
  });
});

// Session beenden
app.delete('/api/v1/sessions/:sessionId', (req, res) => {
  const { sessionId } = req.params;
  const deleted = sessions.delete(sessionId);
  
  if (!deleted) {
    return res.status(404).json({ error: 'Session nicht gefunden' });
  }
  
  res.json({ 
    success: true,
    message: 'Session beendet'
  });
});

// Alle aktiven Sessions (Admin)
app.get('/api/v1/sessions', (req, res) => {
  const sessionList = Array.from(sessions.values()).map(session => ({
    sessionId: session.id,
    messageCount: session.messages.length,
    createdAt: session.createdAt,
    lastActivity: session.lastActivity,
  }));
  
  res.json({
    total: sessionList.length,
    sessions: sessionList,
  });
});

// Server starten
app.listen(PORT, () => {
  console.log(`🚀 Callcenter AI Backend läuft auf Port ${PORT}`);
  console.log(`📊 Health Check: http://localhost:${PORT}/api/v1/health`);
  console.log(`🔑 Gemini API Key: ${GEMINI_API_KEY.substring(0, 10)}...`);
});

// Cleanup: Alte Sessions nach 1 Stunde Inaktivität löschen
setInterval(() => {
  const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000);
  
  for (const [sessionId, session] of sessions.entries()) {
    if (new Date(session.lastActivity) < oneHourAgo) {
      sessions.delete(sessionId);
      console.log(`🧹 Session ${sessionId} gelöscht (inaktiv)`);
    }
  }
}, 5 * 60 * 1000); // Alle 5 Minuten prüfen

