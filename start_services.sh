#!/bin/bash

echo '$XINFERENCE_SERVER_ENDPOINT is: ' ${XINFERENCE_SERVER_ENDPOINT}

# Launch Llama 2 Chat model 
xinference launch --model-name "llama-2-chat" --model-format "ggmlv3" --size-in-billions 13 --endpoint ${XINFERENCE_SERVER_ENDPOINT}

# Launch GTE Embedding model 
xinference launch --model-name "gte-base" --model-type "embedding" --endpoint ${XINFERENCE_SERVER_ENDPOINT}

# Capture the model UID from output
export XINFERENCE_LLM_MODEL_UID=$(python3 -c "from xinference.client import RESTfulClient; c = RESTfulClient('$XINFERENCE_SERVER_ENDPOINT'); data=c.list_models(); print(list(data.keys())[0])")

# Capture the model UID from output
export XINFERENCE_EMBEDDING_MODEL_UID=$(python3 -c "from xinference.client import RESTfulClient; c = RESTfulClient('$XINFERENCE_SERVER_ENDPOINT'); data=c.list_models(); print(list(data.keys())[1])")

# Pass the Model UID via an environment variable
echo "XINFERENCE_EMBEDDING_MODEL_UID is: ${XINFERENCE_EMBEDDING_MODEL_UID}"
echo "XINFERENCE_LLM_MODEL_UID is: ${XINFERENCE_LLM_MODEL_UID}"

# Start Streamlit app
poetry run streamlit run app/main.py --server.port 8501 --server.address 0.0.0.0 &

# Keep the script running
wait