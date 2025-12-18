/**
 * Prüft verfügbare Gemini Modelle
 */

import { GoogleGenerativeAI } from '@google/generative-ai';
import dotenv from 'dotenv';

dotenv.config();

const GEMINI_API_KEY = process.env.GEMINI_API_KEY || 'AIzaSyC4hhRA_tpmX-TXGBsDhfE9B4pmmr1Sfsk';
const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);

async function listModels() {
  try {
    console.log('🔍 Prüfe verfügbare Modelle...\n');
    
    // Versuche verschiedene Modelle
    const modelsToTest = [
      'gemini-pro',
      'gemini-1.5-pro',
      'gemini-1.5-flash',
      'gemini-1.0-pro',
      'models/gemini-pro',
      'models/gemini-1.5-pro',
    ];
    
    for (const modelName of modelsToTest) {
      try {
        const model = genAI.getGenerativeModel({ model: modelName });
        const result = await model.generateContent('Test');
        console.log(`✅ ${modelName} - FUNKTIONIERT`);
      } catch (error) {
        console.log(`❌ ${modelName} - ${error.message.split('\n')[0]}`);
      }
    }
    
    // Versuche Modelle aufzulisten (falls API unterstützt)
    try {
      console.log('\n📋 Versuche Modelle-Liste abzurufen...');
      // Diese Funktion existiert möglicherweise nicht in der SDK-Version
      console.log('⚠️ ListModels API nicht direkt verfügbar');
    } catch (error) {
      console.log('⚠️ Kann Modelle nicht auflisten');
    }
    
  } catch (error) {
    console.error('❌ Fehler:', error.message);
  }
}

listModels();

