# 1. Use a lightweight Python image
FROM python:3.9-slim

# 2. Install system dependencies
# We add build-essential for bcrypt and default-libmysqlclient-dev for MySQL
RUN apt-get update && apt-get install -y \
    gcc \
    build-essential \
    default-libmysqlclient-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# 3. Set working directory
WORKDIR /app

# 4. Install Python dependencies 
# (Doing this before COPY . . helps with Docker caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy the rest of the application code
COPY . .

# 6. Expose the port Flask runs on
EXPOSE 5000

# 7. Set Environment Variables
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# 8. Start the application
CMD ["flask", "run"]
