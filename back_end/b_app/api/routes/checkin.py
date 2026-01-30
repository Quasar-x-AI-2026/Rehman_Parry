from fastapi import APIRouter
from datetime import datetime
from b_app.db.firebase_client import save_checkin
from b_app.services.burnout_service import burnout_from_emotion, burnout_risk
from b_app.services.sentiment_service import analyze_emotion
from pydantic import BaseModel
import os


router = APIRouter()

class CheckinPayload(BaseModel):
    stress: int
    energy: int
    mood: str
    workload: str
    sleep_hours: float
    note: str | None = ""


@router.post("/checkin")
def submit_checkin(payload: CheckinPayload):
    print("📝 BACKEND NOTE TEXT:", repr(payload.note))


    payload = payload.dict()
    user_id = "demo_user_1"

    note_text = payload.get("note")
    print("📝 NOTE TEXT:", repr(note_text))


    if note_text and note_text.strip():
        emotion = analyze_emotion(note_text)
    else:
        emotion = {
            "anger": 0,
            "fear": 0,
            "joy": 0,
            "neutral": 1,
            "sadness": 0
        }
        payload.pop("note", None)  # ⛔ remove empty note

    burnout_score = burnout_from_emotion(emotion)
    burnout_level = burnout_risk(burnout_score)

    now = datetime.utcnow()

    enriched_payload = {
        "burnout": {
            "method": "rule_based_v1",
            "risk": burnout_level,
            "score": burnout_score
        },
        "emotion": emotion,
        "energy": payload["energy"],
        "stress": payload["stress"],
        "sleep_hours": payload["sleep_hours"],
        "workload": payload["workload"],
        "note": note_text,
        "schema_version": 3,
        "created_at": now.isoformat(),
        "date": now.date().isoformat()
    }

    save_checkin(user_id, enriched_payload)

    return enriched_payload

