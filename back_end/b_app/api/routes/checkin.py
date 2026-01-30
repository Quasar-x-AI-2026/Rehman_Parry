from fastapi import APIRouter
from datetime import datetime
from b_app.db.firebase_client import db

router = APIRouter()

@router.post("/checkin")
def submit_checkin(data: dict):
    user_id = "demo_user_1"  # hackathon phase
    date_id = datetime.utcnow().strftime("%Y-%m-%d")

    payload = {
        "stress": data["stress"],
        "energy": data["energy"],
        "mood": data["mood"],
        "workload": data["workload"],
        "sleep_hours": data["sleep_hours"],
        "created_at": datetime.utcnow()
    }

    db.collection("users") \
      .document(user_id) \
      .collection("checkins") \
      .document(date_id) \
      .set(payload)

    return {
        "status": "success",
        "date": date_id
    }
