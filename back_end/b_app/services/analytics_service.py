from statistics import mean

def analyze_checkins(checkins: list[dict]):
    """
    Layer 1 analytics:
    - Uses last 7 daily check-ins
    - Assumes stress & energy scale: 1–5
    - checkins MUST be ordered oldest → newest
    """

    if not checkins:
        return {"status": "no_data"}

    stress = [c["stress"] for c in checkins if "stress" in c]
    energy = [c["energy"] for c in checkins if "energy" in c]

    avg_stress_7d = round(mean(stress), 1)
    avg_energy_7d = round(mean(energy), 1)

    # Consecutive high-stress days (from latest backwards)
    consecutive_high = 0
    for c in reversed(checkins):
        if c.get("stress", 0) >= 4:
            consecutive_high += 1
        else:
            break

    # Stress trend (compare recent 3 vs previous 3)
    trend = "stable"
    if len(stress) >= 6:
        recent = mean(stress[-3:])
        previous = mean(stress[-6:-3])
        if recent > previous:
            trend = "increasing"
        elif recent < previous:
            trend = "decreasing"

    return {
        "days_tracked": len(checkins),
        "avg_stress_7d": avg_stress_7d,
        "avg_energy_7d": avg_energy_7d,
        "stress_trend": trend,
        "consecutive_high_stress_days": consecutive_high,
        "low_energy_flag": avg_energy_7d <= 2.5
    }
