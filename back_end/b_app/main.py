from fastapi import FastAPI
from b_app.api.routes import checkin, risk

app = FastAPI()

app.include_router(checkin.router)
app.include_router(risk.router)
