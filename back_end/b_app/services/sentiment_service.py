from transformers import pipeline
import os

# --- Hugging Face hard disable network & extras ---
os.environ["HF_HUB_DISABLE_TELEMETRY"] = "1"
os.environ["HF_HUB_DISABLE_SYMLINKS_WARNING"] = "1"
os.environ["HF_HUB_OFFLINE"] = "1"
os.environ["TRANSFORMERS_OFFLINE"] = "1"
os.environ["HF_HUB_DISABLE_PROGRESS_BARS"] = "1"
os.environ["TRANSFORMERS_NO_ADVISORY_WARNINGS"] = "1"
os.environ["HF_HUB_ENABLE_HF_TRANSFER"] = "0"


emotion_pipeline = pipeline(
    "text-classification",
    model="j-hartmann/emotion-english-distilroberta-base",
    return_all_scores=True
)

def analyze_emotion(text: str):
    # Fallback for empty input
    if not text or text.strip() == "":
        return {
            "sadness": 0.0,
            "fear": 0.0,
            "anger": 0.0,
            "joy": 0.0,
            "neutral": 1.0
        }

    raw_output = emotion_pipeline(text)

    # Normalize output shape
    if isinstance(raw_output[0], list):
        results = raw_output[0]
    else:
        results = raw_output

    # Initialize all required emotions
    emotion_scores = {
        "sadness": 0.0,
        "fear": 0.0,
        "anger": 0.0,
        "joy": 0.0,
        "neutral": 0.0
    }

    for item in results:
        label = item["label"].lower()
        score = round(item["score"], 3)

        if label == "surprise":
            continue

        if label in emotion_scores:
            emotion_scores[label] = score

    return emotion_scores


if __name__ == "__main__":
    tests = [
        "I am tired all the time, but I’m still pushing myself to get things done.",
        "There’s so much pressure at work and I constantly feel like I’m falling behind.",
        "I feel angry about work",
        "Just another normal day",
        ""
    ]

    for t in tests:
        print("\nTEXT:", repr(t))
        print("EMOTION:", analyze_emotion(t))
        print("SUM:", round(sum(analyze_emotion(t).values()), 3))

