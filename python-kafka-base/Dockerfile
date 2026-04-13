# Use the lightweight Python image
FROM python:3.11-slim

# Install system dependencies required by kafka-python and similar libs
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy your application code
COPY . /app
WORKDIR /app

# Default command (adjust if you want consumer.py instead)
CMD ["python", "producer.py"]
