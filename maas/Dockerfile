FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

RUN apt-get update && apt-get install -y python3 python3-pip

# Install Xinference
RUN apt-get install -y git && pip install git+https://github.com/xorbitsai/inference.git@main#egg=xinference[ggml]
#RUN pip install xinference[ggml]==0.4.1

# For Xinference Embedding models
RUN pip install sentence-transformers

# For GGML models
RUN CMAKE_ARGS="-DLLAMA_CUBLAS=on" FORCE_CMAKE=1 pip install llama-cpp-python==0.1.78 --force-reinstall --upgrade --no-cache-dir

EXPOSE 8001
