
'''See its the current rule based , will replace with ML based later'''
def emotion_strain(emotion: dict) -> float:
    sadness = emotion.get("sadness", 0.0)
    fear = emotion.get("fear", 0.0)
    anger = emotion.get("anger", 0.0)
    joy = emotion.get("joy", 0.0)

    score = (
        0.4 * sadness +
        0.4 * fear +
        0.2 * anger -
        0.3 * joy
    )

    return max(0.0, min(score, 1.0))


def physiological_strain(energy: int, sleep_hours: float) -> float:
    energy_score = 1 - (energy / 10.0)
    sleep_score = 1 - min(sleep_hours / 8.0, 1.0)

    score = 0.6 * energy_score + 0.4 * sleep_score
    return max(0.0, min(score, 1.0))


def cognitive_strain(stress: int, workload: str) -> float:
    stress_score = stress / 5.0

    workload_score = {
        "Low": 0.2,
        "Medium": 0.5,
        "High": 0.8
    }.get(workload, 0.5)

    score = 0.6 * stress_score + 0.4 * workload_score
    return max(0.0, min(score, 1.0))

def burnout_score(
    emotion: dict,
    energy: int,
    sleep_hours: float,
    stress: int,
    workload: str,
) -> float:
    e_strain = emotion_strain(emotion)
    p_strain = physiological_strain(energy, sleep_hours)
    c_strain = cognitive_strain(stress, workload)

    # Weighted fusion (interpretable)
    score = (
        0.45 * e_strain +
        0.35 * p_strain +
        0.20 * c_strain
    )

    return round(max(0.0, min(score, 1.0)), 3)


def burnout_risk(score: float) -> str:
    if score < 0.30:
        return "LOW"
    elif score < 0.60:
        return "MEDIUM"
    else:
        return "HIGH"