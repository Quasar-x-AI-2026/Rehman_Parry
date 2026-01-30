from fastapi import APIRouter
from datetime import datetime
from b_app.db.firebase_client import db, save_checkin

router = APIRouter()

@router.post("/checkin")
def submit_checkin(payload: dict):
    user_id = "demo_user_1"  # hackathon phase
    save_checkin(user_id, payload)
    return {"status": "ok"}
