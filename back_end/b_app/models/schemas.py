from pydantic import BaseModel
from typing import Optional


class CheckInRequest(BaseModel):
    energy: int               # 1–10
    workload: str             # low / medium / high
    note: Optional[str] = None


class CheckInResponse(BaseModel):
    sentiment_label: str
    sentiment_score: float
