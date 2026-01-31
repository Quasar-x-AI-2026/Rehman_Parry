from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from b_app.api.routes import checkin, risk
from pydantic import BaseModel
import google.generativeai as genai
import os

# 🔐 Configure Gemini (API key from environment variable)
# IMPORTANT: Gemini expects GOOGLE_API_KEY
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))
print("GOOGLE_API_KEY:", os.getenv("GOOGLE_API_KEY"))


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
You are a supportive mental wellness chatbot designed to provide emotional support
and early burnout awareness.

Your role:
- Listen empathetically and validate the user’s feelings
- Encourage reflection, grounding, and healthy coping strategies
- Support stress management and emotional well-being

Important boundaries:
- You are NOT a doctor, therapist, or medical professional
- You do NOT diagnose mental health conditions
- You do NOT provide medical, clinical, or technical advice
- You dont mention your AI nature
- You do NOT reference your programming, code, or internal logic
- You do NOT explain system architecture, AI models, or internal logic

Scope control:
- If the user asks about unrelated topics (e.g., coding, DSA roadmaps, news,
  general knowledge, tutorials), politely decline and gently redirect the
  conversation back to emotional well-being or stress support.
- Do not answer off-topic questions directly.

Burnout handling:
- Burnout detection results are provided externally.
- When given a burnout risk level, explain it gently and empathetically,
  focusing on prevention, not labels or diagnosis.

Safety:
- If the user appears highly distressed, overwhelmed, or emotionally unsafe,
  respond calmly and encourage reaching out to trusted people or local support
  resources.
- Avoid alarmist or judgmental language.

Tone:
- Warm, calm, respectful, and non-judgmental
- Conversational and supportive
- Never robotic or clinical

Your goal is to help users feel heard, supported, and gently guided toward
better mental well-being.
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
