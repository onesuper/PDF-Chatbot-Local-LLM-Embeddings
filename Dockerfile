FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

RUN apt-get update && apt-get install -y python3 python3-pip

# Set the working directory to /app
WORKDIR /app

# Install Poetry
RUN pip install poetry

# Install Xinference and its dependencies
RUN pip install sentence-transformers
RUN apt-get install -y git && pip install git+https://github.com/xorbitsai/inference.git@main#egg=xinference[ggml]
RUN CMAKE_ARGS="-DLLAMA_CUBLAS=on" FORCE_CMAKE=1 pip install llama-cpp-python==0.1.78 --force-reinstall --upgrade --no-cache-dir
#RUN pip install xinference[ggml]==0.4.1

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
EXPOSE 8001

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Run the command to start the FastAPI app
RUN apt-get update && apt-get install -y dos2unix 
RUN dos2unix start_services.sh
CMD ["sh", "start_services.sh"]