FROM python:alpine AS base

RUN mkdir -p /app
COPY api.py /app
COPY requirements.txt /app
WORKDIR /app
RUN pip install -r /app/requirements.txt
RUN apk add curl
CMD ["gunicorn","-b","0.0.0.0:8000","--log-level","debug", "api:app"]

COPY comentarios.sh /app
WORKDIR /app
RUN chmod +x comentarios.sh

EXPOSE 8000