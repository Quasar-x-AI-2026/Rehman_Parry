from fastapi import APIRouter
from b_app.db.firebase_client import get_last_n_checkins
from b_app.services.analytics_service import (
    analyze_checkins,
    build_risk_explanation,
    extract_stress_series,
    smooth_burnout_score,
)

router = APIRouter()

@router.get("/risk")
def get_risk():
    user_id = "demo_user_1"
    


    checkins = get_last_n_checkins(user_id, 7)
    if not checkins:
        return {
        "current": None,
        "trend": None,
        "explanation": "Not enough data yet. Check in for a few days to see your risk.",
        "stress_series": []
    }


    analytics = analyze_checkins(checkins)
    print("ANALYTICS:", analytics)
    latest = checkins[-1]
    
    burnout = latest.get("burnout", {})

    return {
        "current": {
            "risk": burnout.get("risk", "UNKNOWN"),
            "score": burnout.get("score", 0.0),
            "updated_at": latest.get("created_at")
        },
        "trend": {
            "direction": analytics.get("stress_trend", "stable")
        },
        "explanation": build_risk_explanation(analytics),
        "stress_series": extract_stress_series(checkins)
    }
