FROM python:3.11
WORKDIR /app

# Install dependencies once at build time
RUN pip install --no-cache-dir kafka-python

# Default command (overridden in docker-compose)
CMD ["python", "app.py"]
