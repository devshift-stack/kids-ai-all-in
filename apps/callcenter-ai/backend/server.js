import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { GoogleGenerativeAI } from '@google/generative-ai';
import { v4 as uuidv4 } from 'uuid';
import rateLimit from 'express-rate-limit';
import { getSystemPrompt } from './language_prompts.js';
import { AgentFactory, AGENT_TYPES, PRODUCT_CATEGORIES } from './premium_agents.js';

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

// Factory-Funktion für Model mit Sprache
function createModel(language = 'german') {
  return genAI.getGenerativeModel({ 
    model: 'gemini-1.5-flash',
    generationConfig: {
      temperature: 0.8,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 512,
    },
    systemInstruction: getSystemPrompt(language),
  });
}

// Session Storage (In-Memory - für Production: Datenbank verwenden)
const sessions = new Map();

// System-Prompts sind jetzt in language_prompts.js

// API Routes

// Health Check
app.get('/api/v1/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    activeSessions: sessions.size,
    timestamp: new Date().toISOString()
  });
});

// Neue Session erstellen (Legacy - mit language_prompts.js)
app.post('/api/v1/sessions', (req, res) => {
  const { language = 'german' } = req.body;
  const sessionId = uuidv4();
  const modelInstance = createModel(language);
  const chat = modelInstance.startChat();
  
  const session = {
    id: sessionId,
    chat: chat,
    language: language,
    messages: [],
    createdAt: new Date().toISOString(),
    lastActivity: new Date().toISOString(),
  };
  
  sessions.set(sessionId, session);
  
  // Begrüßung von Lisa (sprachabhängig)
  const greetings = {
    german: 'Hallo! Ich bin Lisa, Ihre Verkaufsberaterin. Schön, dass ich Sie erreiche! Wie geht es Ihnen heute? Ich rufe an, um über Solarmodule zu sprechen – haben Sie sich schon einmal Gedanken über Solarstrom gemacht?',
    bosnian: 'Zdravo! Ja sam Lisa, vaša prodajna savjetnica. Drago mi je što vas mogu kontaktirati! Kako ste danas? Zovem vas da razgovorimo o solarnim panelima – da li ste ikada razmišljali o solarnoj energiji?',
    serbian: 'Zdravo! Ja sam Lisa, vaša prodajna savetnica. Drago mi je što vas mogu kontaktirati! Kako ste danas? Zovem vas da razgovorimo o solarnim panelima – da li ste ikada razmišljali o solarnoj energiji?',
  };
  
  const greeting = greetings[language] || greetings.german;
  
  session.messages.push({
    role: 'assistant',
    text: greeting,
    timestamp: new Date().toISOString(),
  });
  
  res.json({
    sessionId: sessionId,
    greeting: greeting,
    language: language,
    createdAt: session.createdAt,
  });
});

// Premium Agent Session erstellen (NEU)
app.post('/api/v1/premium/sessions', (req, res) => {
  const { 
    agentType = 'sales', 
    productCategory = 'solar', 
    language = 'german' 
  } = req.body;
  
  const sessionId = uuidv4();
  
  // Erstelle Premium Agent
  let agent;
  try {
    if (agentType === 'sales') {
      agent = AgentFactory.createSalesAgent(productCategory, language);
    } else if (agentType === 'vertrieb') {
      agent = AgentFactory.createVertriebAgent(productCategory, language);
    } else if (agentType === 'kundendienst') {
      agent = AgentFactory.createKundendienstAgent(productCategory, language);
    } else if (agentType === 'innendienst') {
      agent = AgentFactory.createInnendienstAgent(productCategory, language);
    } else {
      return res.status(400).json({ error: `Unbekannter Agent-Typ: ${agentType}` });
    }
    
    const chat = agent.startChat();
    
    const session = {
      id: sessionId,
      agent: agent,
      chat: chat,
      agentType: agentType,
      productCategory: productCategory,
      language: language,
      agentName: agent.name,
      messages: [],
      createdAt: new Date().toISOString(),
      lastActivity: new Date().toISOString(),
    };
    
    sessions.set(sessionId, session);
    
    // Begrüßung basierend auf Agent und Produkt
    const greeting = getPremiumGreeting(agentType, productCategory, language, agent.name);
    
    session.messages.push({
      role: 'assistant',
      text: greeting,
      timestamp: new Date().toISOString(),
    });
    
    res.json({
      sessionId: sessionId,
      greeting: greeting,
      agentType: agentType,
      productCategory: productCategory,
      language: language,
      agentName: agent.name,
      createdAt: session.createdAt,
    });
  } catch (error) {
    console.error('Premium Agent Error:', error);
    res.status(500).json({ error: 'Fehler beim Erstellen des Premium Agents' });
  }
});

// Premium Agent Begrüßungen
function getPremiumGreeting(agentType, productCategory, language, agentName) {
  const greetings = {
    sales: {
      solar: {
        german: `Hallo! Ich bin ${agentName}, Ihre Verkaufsberaterin für Solarmodule. Schön, dass ich Sie erreiche! Wie geht es Ihnen heute? Ich rufe an, um über Solarmodule zu sprechen – haben Sie sich schon einmal Gedanken über Solarstrom gemacht?`,
      },
      strom: {
        german: `Hallo! Ich bin ${agentName}, Ihr Berater für Stromverträge. Schön, dass ich Sie erreiche! Ich rufe an, um Ihnen zu helfen, Ihre Stromkosten zu senken. Wie hoch sind denn aktuell Ihre monatlichen Stromkosten?`,
      },
      handy: {
        german: `Hallo! Ich bin ${agentName}, Ihr Berater für Handyverträge. Schön, dass ich Sie erreiche! Ich rufe an, um Ihnen passende Handyverträge und Smartphones anzubieten. Welches Gerät nutzen Sie aktuell?`,
      }
    },
    vertrieb: {
      solar: {
        german: `Guten Tag! Ich bin ${agentName} vom Vertrieb. Ich rufe an, um über größere Solarprojekte für Ihr Unternehmen zu sprechen. Haben Sie bereits Erfahrung mit Solarenergie?`,
      }
    },
    kundendienst: {
      solar: {
        german: `Hallo! Ich bin ${agentName} vom Kundendienst. Wie kann ich Ihnen heute helfen?`,
      }
    },
    innendienst: {
      solar: {
        german: `Guten Tag! Ich bin ${agentName} vom Innendienst. Wie kann ich Sie unterstützen?`,
      }
    }
  };
  
  return greetings[agentType]?.[productCategory]?.[language] || 
         `Hallo! Ich bin ${agentName}. Wie kann ich Ihnen helfen?`;
}

// Nachricht an Session senden (Legacy)
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

// Premium Agent Chat (NEU)
app.post('/api/v1/premium/sessions/:sessionId/chat', async (req, res) => {
  const { sessionId } = req.params;
  const { message } = req.body;
  
  if (!message || typeof message !== 'string') {
    return res.status(400).json({ error: 'Message ist erforderlich' });
  }
  
  const session = sessions.get(sessionId);
  if (!session) {
    return res.status(404).json({ error: 'Session nicht gefunden' });
  }
  
  // Prüfe ob Premium Agent Session
  if (!session.agent) {
    return res.status(400).json({ error: 'Keine Premium Agent Session' });
  }
  
  try {
    // User-Nachricht speichern
    session.messages.push({
      role: 'user',
      text: message,
      timestamp: new Date().toISOString(),
    });
    
    // Premium Agent verwenden
    const response = await session.agent.sendMessage(message);
    
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
      agentName: session.agentName,
      agentType: session.agentType,
      productCategory: session.productCategory,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Premium Agent Error:', error);
    
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
    language: session.language || 'german',
    messageCount: session.messages.length,
    createdAt: session.createdAt,
    lastActivity: session.lastActivity,
  }));
  
  res.json({
    total: sessionList.length,
    sessions: sessionList,
  });
});

// Monitoring & Statistiken
app.get('/api/v1/stats', (req, res) => {
  const now = new Date();
  const todayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  
  let totalMessages = 0;
  let messagesToday = 0;
  const languageStats = {};
  
  for (const session of sessions.values()) {
    totalMessages += session.messages.length;
    
    const sessionMessages = session.messages.filter(msg => {
      const msgDate = new Date(msg.timestamp);
      return msgDate >= todayStart;
    });
    messagesToday += sessionMessages.length;
    
    const lang = session.language || 'german';
    languageStats[lang] = (languageStats[lang] || 0) + 1;
  }
  
  res.json({
    activeSessions: sessions.size,
    totalMessages: totalMessages,
    messagesToday: messagesToday,
    languageDistribution: languageStats,
    timestamp: now.toISOString(),
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

