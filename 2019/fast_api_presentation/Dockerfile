FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

COPY truetime.py /app/truetime.py
COPY bustimes.py /app/main.py
COPY requirements.txt /app
WORKDIR /app
RUN pip install -r requirements.txt
