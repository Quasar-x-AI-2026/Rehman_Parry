
from datetime import datetime , timezone
from b_app.db.firebase_client import save_checkin
from b_app.services.sentiment_service import analyze_emotion
from b_app.services.burnout_service import burnout_from_emotion, burnout_risk

user_id = "demo_user_1"

test_checkins = [
    {
  "date": "2026-01-30",
  "note": "Today felt heavier than usual.\nI managed to get through work, but my energy was low and I kept feeling mentally drained.",
  "energy": 4,
  "sleep_hours": 6,
  "stress": 3,
  "workload": 3
}
,
    {
        "date": "2026-01-31",
        "note": "Feeling okay today.\nWork was manageable but I still felt tired by evening.",
        "energy": 5,
        "sleep_hours": 6,
        "stress": 3,
        "workload": 3
    },
    {
        "date": "2026-02-01",
        "note": "I woke up already exhausted.\nMeetings kept piling up and I couldn’t focus properly.",
        "energy": 3,
        "sleep_hours": 5,
        "stress": 4,
        "workload": 4
    },
    {
        "date": "2026-02-02",
        "note": "Feeling anxious about deadlines.\nEven small tasks feel overwhelming lately.",
        "energy": 3,
        "sleep_hours": 5,
        "stress": 5,
        "workload": 4
    },
    {
        "date": "2026-02-03",
        "note": "I felt irritated most of the day.\nSmall things annoyed me more than usual.",
        "energy": 4,
        "sleep_hours": 6,
        "stress": 4,
        "workload": 3
    },
    {
        "date": "2026-02-04",
        "note": "Work went fine today.\nI was productive but still felt mentally drained.",
        "energy": 5,
        "sleep_hours": 6,
        "stress": 3,
        "workload": 3
    },
    {
        "date": "2026-02-05",
        "note": "I don’t feel particularly stressed.\nBut I also don’t feel motivated or excited about work anymore.",
        "energy": 4,
        "sleep_hours": 7,
        "stress": 2,
        "workload": 3
    },
    {
        "date": "2026-02-06",
        "note": "Feeling slightly better today.\nManaged to finish tasks without too much pressure.",
        "energy": 6,
        "sleep_hours": 7,
        "stress": 2,
        "workload": 2
    },
    {
        "date": "2026-02-07",
        "note": "Today was calm.\nNo major stress but still feeling a bit disconnected.",
        "energy": 6,
        "sleep_hours": 7,
        "stress": 2,
        "workload": 2
    }
]

for entry in test_checkins:
    emotion = analyze_emotion(entry["note"])
    burnout_score = burnout_from_emotion(emotion)
    burnout_level = burnout_risk(burnout_score)

    payload = {
        **entry,
        "emotion": emotion,
        "burnout": {
            "score": burnout_score,
            "risk": burnout_level,
            "method": "rule_based_v1"
        },
        "schema_version": 3,
        "created_at": datetime.now(timezone.utc).isoformat()
    }

    save_checkin(user_id, payload)
    print(f"Uploaded check-in for {entry['date']}")
