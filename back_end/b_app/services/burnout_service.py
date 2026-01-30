
'''See its the current rule based , will replace with ML based later'''
def burnout_from_emotion(emotion: dict) -> float:
    sadness = emotion.get("sadness", 0.0)
    fear = emotion.get("fear", 0.0)
    anger = emotion.get("anger", 0.0)
    neutral = emotion.get("neutral", 0.0)
    joy = emotion.get("joy", 0.0)

    score = (
        0.40 * sadness +
        0.35 * fear +
        0.15 * anger +
        0.10 * neutral -
        0.30 * joy
    )

    return round(max(0.0, min(score, 1.0)), 3)

def burnout_risk(score: float) -> str:
    if score < 0.34:
        return "LOW"
    elif score < 0.67:
        return "MEDIUM"
    else:
        return "HIGH"
