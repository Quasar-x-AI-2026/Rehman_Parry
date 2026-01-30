from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import google.generativeai as genai
import os

# 🔐 Configure Gemini (API key from environment variable)
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

# ✅ Use a model that EXISTS and supports generateContent
model = genai.GenerativeModel("gemini-flash-latest")

app = FastAPI()

# ✅ Enable CORS for Flutter Web / Mobile
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class ChatRequest(BaseModel):
    message: str

class ChatResponse(BaseModel):
    reply: str

SYSTEM_PROMPT = """
You are a supportive mental wellness chatbot.
Rules:
- Be empathetic, calm, and supportive
- Do NOT diagnose
- Do NOT give medical advice
- Encourage healthy reflection
- If the user sounds suicidal, gently suggest professional help
"""

@app.post("/chat", response_model=ChatResponse)
def chat(req: ChatRequest):
    try:
        prompt = f"{SYSTEM_PROMPT}\nUser: {req.message}\nAI:"
        response = model.generate_content(prompt)
        return {"reply": response.text}
    except Exception as e:
        print("Error:", e)
        raise HTTPException(status_code=500, detail="AI generation failed")

@app.get("/")
def root():
    return {"status": "Backend is running"}
