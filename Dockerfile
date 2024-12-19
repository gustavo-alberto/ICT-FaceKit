# Base image
FROM python:3.8-slim

# Update the system and install required dependencies for CMake and compilation
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    gcc \
    g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the Python dependency file into the container
COPY requirements.txt /app/

# Set up a virtual environment, upgrade pip, and install dependencies
RUN python -m venv /app/venv && \
    /app/venv/bin/pip install --no-cache-dir --upgrade pip && \
    /app/venv/bin/pip install --no-cache-dir -r /app/requirements.txt

# Copy all project files to the working directory
COPY . /app/

# Create a persistent volume for storing output data
VOLUME ["/app/sample_data_out"]

# Define the default command to run when the container starts
CMD ["/bin/bash", "-c", ". /app/venv/bin/activate \
    && python Scripts/sample_random.py \
    && python Scripts/read_identity.py"]
