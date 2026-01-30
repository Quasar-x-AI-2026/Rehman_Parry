from fastapi import APIRouter
from datetime import datetime
from b_app.db.firebase_client import save_checkin
from b_app.services.burnout_service import burnout_from_emotion, burnout_risk
from b_app.services.sentiment_service import analyze_emotion

router = APIRouter()

@router.post("/checkin")
def submit_checkin(payload: dict):
    user_id = "demo_user_1"  # hackathon phase

    note_text = payload.get("note", "")

    # Run emotion analysis on note
    emotion = analyze_emotion(note_text)
    burnout_score = burnout_from_emotion(emotion)
    burnout_level = burnout_risk(burnout_score)

    enriched_payload = {
        **payload,
        "emotion": emotion,
        "burnout": {
            "score": burnout_score,
            "risk": burnout_level,
            "method": "rule_based_v1"
        },
        "schema_version": 3,
        "created_at": datetime.utcnow().isoformat()
    }

    save_checkin(user_id, enriched_payload)

    return {
        "status": "ok",
        "burnout": enriched_payload["burnout"]
    }
