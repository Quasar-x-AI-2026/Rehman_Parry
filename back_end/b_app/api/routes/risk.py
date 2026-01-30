from fastapi import APIRouter
from b_app.db.firebase_client import get_last_n_checkins
from b_app.services.analytics_service import (
    analyze_checkins,
    build_risk_explanation,
    extract_stress_series,
)

router = APIRouter()

@router.get("/risk")
def get_risk():
    user_id = "demo_user_1"
    


    checkins = get_last_n_checkins(user_id, 7)
    if not checkins:
        return {"status": "no_data"}

    analytics = analyze_checkins(checkins)
    print("ANALYTICS:", analytics)
    latest = checkins[-1]

    return {
        "current": {
            "risk": latest["burnout"]["risk"],
            "score": latest["burnout"]["score"],
            "updated_at": latest["created_at"]
        },
        "trend": {
            "direction": analytics["stress_trend"]
        },
        "explanation": build_risk_explanation(analytics),
        "stress_series": extract_stress_series(checkins)
    }
