from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from b_app.api.routes import checkin, risk
from pydantic import BaseModel
import google.generativeai as genai
import os

# 🔐 Configure Gemini (API key from environment variable)
# IMPORTANT: Gemini expects GOOGLE_API_KEY
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

# ✅ Use a valid Gemini model
model = genai.GenerativeModel("gemini-flash-latest")

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],   # OK for hackathon
    allow_credentials=True,
    allow_methods=["*"],   # enables OPTIONS
    allow_headers=["*"],
)

app.include_router(checkin.router)
app.include_router(risk.router)

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
