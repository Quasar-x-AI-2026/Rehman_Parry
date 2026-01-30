from fastapi import APIRouter
from b_app.db.firebase_client import get_last_n_checkins
from b_app.services.analytics_service import analyze_checkins

router = APIRouter()

@router.get("/risk")
def get_risk():
    user_id = "demo_user_1"
    checkins = get_last_n_checkins(user_id)

    signals = analyze_checkins(checkins)

    return {
        "signals": signals,
        "days_tracked": len(checkins)
    }
