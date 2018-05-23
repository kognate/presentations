FROM python:3.6.5-alpine
WORKDIR /app
ADD app.py .
RUN apk add --no-cache gcc musl-dev g++
ADD requirements.txt .
RUN pip install -r requirements.txt
RUN python -m spacy download en
ADD ./gina_haspel ./gina_haspel
ADD config.py .
EXPOSE 8000
CMD ["gunicorn", "--config", "/app/config.py", "app:app"]
