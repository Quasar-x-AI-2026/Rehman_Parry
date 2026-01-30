import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate("firebase_key.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

def get_last_n_checkins(user_id: str, n: int = 7):
    ref = (
        db.collection("users")
        .document(user_id)
        .collection("checkins")
        .order_by("created_at", direction=firestore.Query.DESCENDING)
        .limit(n)
    )

    docs = ref.stream()
    checkins = [doc.to_dict() for doc in docs]

    # oldest → newest
    return list(reversed(checkins))
