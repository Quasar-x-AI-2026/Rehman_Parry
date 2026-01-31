from datetime import datetime, timezone
import firebase_admin
from firebase_admin import credentials, firestore
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
KEY_PATH = os.path.join(BASE_DIR, "firebase_key.json")

if not firebase_admin._apps:
    cred = credentials.Certificate(KEY_PATH)
    firebase_admin.initialize_app(cred)

db = firestore.client()

def save_checkin(user_id: str, data: dict):
    """
    Saves exactly ONE check-in per day.
    Same day = overwrite.
    New day = new document.
    """

    today=datetime.now(timezone.utc).date().isoformat()
    
    data["created_at"]=datetime.now(timezone.utc)
    data["date"]=today

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

def get_checkins_in_range(user_id: str, start: date, end: date):
    """
    Fetch check-ins between start and end dates (inclusive)
    """
    start_str = start.isoformat()
    end_str = end.isoformat()

    ref = (
        db.collection("users")
          .document(user_id)
          .collection("checkins")
          .where("date", ">=", start_str)
          .where("date", "<=", end_str)
          .order_by("date")
    )

    return [doc.to_dict() for doc in ref.stream()]