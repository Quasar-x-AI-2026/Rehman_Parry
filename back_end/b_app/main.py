from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from b_app.api.routes import checkin, risk

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # OK for hackathon
    allow_credentials=True,
    allow_methods=["*"],  # THIS enables OPTIONS
    allow_headers=["*"],
)

app.include_router(checkin.router)
app.include_router(risk.router)
