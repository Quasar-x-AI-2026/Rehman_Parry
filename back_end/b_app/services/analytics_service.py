from statistics import mean

def analyze_checkins(checkins):
    if not checkins:
        return {}

    stress = [c["stress"] for c in checkins]
    energy = [c["energy"] for c in checkins]

    avg_stress_7d = round(mean(stress), 1)
    avg_energy_7d = round(mean(energy), 1)

    consecutive_high = 0
    for c in reversed(checkins):
        if c["stress"] >= 70:
            consecutive_high += 1
        else:
            break

    trend = "stable"
    if len(stress) >= 6:
        recent = mean(stress[-3:])
        previous = mean(stress[-6:-3])
        if recent > previous:
            trend = "increasing"
        elif recent < previous:
            trend = "decreasing"

    return {
        "avg_stress_7d": avg_stress_7d,
        "avg_energy_7d": avg_energy_7d,
        "stress_trend": trend,
        "consecutive_high_stress_days": consecutive_high,
        "low_energy_flag": avg_energy_7d < 45
    }
