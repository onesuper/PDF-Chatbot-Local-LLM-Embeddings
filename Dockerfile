FROM python:3.9

# Set the working directory to /app
WORKDIR /app

# Install Poetry
RUN pip install poetry

# Copy pyproject.toml and poetry.lock files into the container
COPY pyproject.toml poetry.lock /app/

# Install dependencies
RUN poetry config virtualenvs.create false \
  && poetry install --no-interaction --no-ansi \
  && poetry shell

# Copy the start_services.sh script
COPY start_services.sh /app/

# Copy the rest of the application's code
COPY app /app/app

# Make port 8501 available to the world outside this container
EXPOSE 8501

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Install xinference as client
RUN pip install xinference

# Run the command to start the FastAPI app
RUN apt-get update && apt-get install -y dos2unix 
RUN dos2unix start_services.sh
CMD ["sh", "start_services.sh"]