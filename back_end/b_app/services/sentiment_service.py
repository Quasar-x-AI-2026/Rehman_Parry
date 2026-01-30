import os
import torch
import torch.nn.functional as F
from transformers import AutoTokenizer, AutoModelForSequenceClassification

# --------------------------------------------------
# 🔒 Hugging Face OFFLINE + QUIET MODE
# (safe AFTER model has been cached once)
# --------------------------------------------------
os.environ["HF_HUB_DISABLE_TELEMETRY"] = "1"
os.environ["HF_HUB_DISABLE_SYMLINKS_WARNING"] = "1"
os.environ["HF_HUB_DISABLE_AUTO_CONVERSION"] = "1"
os.environ["HF_HUB_OFFLINE"] = "1"
os.environ["TRANSFORMERS_OFFLINE"] = "1"
os.environ["HF_HUB_DISABLE_PROGRESS_BARS"] = "1"
os.environ["TRANSFORMERS_NO_ADVISORY_WARNINGS"] = "1"
os.environ["HF_HUB_ENABLE_HF_TRANSFER"] = "0"

# --------------------------------------------------
# 🧠 MODEL SETUP (REAL TRANSFORMERS USAGE)
# --------------------------------------------------
MODEL_NAME = "j-hartmann/emotion-english-distilroberta-base"

tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
model = AutoModelForSequenceClassification.from_pretrained(MODEL_NAME)
model.eval()

# Model label order (fixed for this model)
LABELS = ["anger", "disgust", "fear", "joy", "neutral", "sadness"]

# --------------------------------------------------
# 🔍 EMOTION ANALYSIS FUNCTION
# --------------------------------------------------
def analyze_emotion(text: str) -> dict:
    """
    Returns a normalized emotion distribution:
    sadness, fear, anger, joy, neutral
    """
    print("🔥 analyze_emotion CALLED with:", repr(text))

    # Fallback for empty input
    if not text or text.strip() == "":
        return {
            "sadness": 0.0,
            "fear": 0.0,
            "anger": 0.0,
            "joy": 0.0,
            "neutral": 1.0
        }

    # Tokenize input
    inputs = tokenizer(
        text,
        return_tensors="pt",
        truncation=True,
        padding=True
    )

    # Run model
    with torch.no_grad():
        outputs = model(**inputs)
        logits = outputs.logits[0]

    # Convert logits → probabilities
    probs = F.softmax(logits, dim=-1).tolist()

    # Map labels → probabilities
    raw_emotions = dict(zip(LABELS, probs))

    # Remove unwanted emotion
    raw_emotions.pop("disgust", None)

    # Normalize again after removal
    total = sum(raw_emotions.values())
    if total > 0:
        for k in raw_emotions:
            raw_emotions[k] = round(raw_emotions[k] / total, 3)

    return raw_emotions


# --------------------------------------------------
# 🧪 LOCAL TESTING
# --------------------------------------------------
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
        result = analyze_emotion(t)
        print("EMOTION:", result)
        print("SUM:", round(sum(result.values()), 3))
