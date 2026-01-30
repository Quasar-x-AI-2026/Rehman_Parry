from datetime import datetime, timezone
import firebase_admin
from firebase_admin import credentials, firestore
import os

if not firebase_admin._apps:
    cred = credentials.Certificate("firebase_key.json")
    firebase_admin.initialize_app(cred)

db = firestore.client()

def save_checkin(user_id: str, data: dict):
    """
    Saves exactly ONE check-in per day.
    Same day = overwrite.
    New day = new document.
    """

    today = datetime.now(timezone.utc).date().isoformat()  # "2026-01-30"

    data["created_at"] = datetime.utcnow()
    data["date"] = today  # optional but useful

    db.collection("users") \
      .document(user_id) \
      .collection("checkins") \
      .document(today) \
      .set(data)

def get_last_n_checkins(user_id: str, n: int):
    ref = (
        db.collection("users")
          .document(user_id)
          .collection("checkins")
          .order_by("date", direction=firestore.Query.DESCENDING)
          .limit(n)
    )

    # oldest → newest
    return list(reversed([doc.to_dict() for doc in ref.stream()]))

