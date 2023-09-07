#!/bin/bash

# Start Xinference local server
xinference --port 8001 &

sleep 5

export XINFERENCE_SERVER_ENDPOINT="http://0.0.0.0:8001"

# Launch Llama 2 Chat model 
xinference launch --model-name "llama-2-chat" --model-format ggmlv3 --size-in-billions 13 -e ${XINFERENCE_SERVER_ENDPOINT}

# Capture the model UID from output
export OUTPUT=$(python -c "from xinference.client import Client; c = Client('http://0.0.0.0:8001'); data=c.list_models(); print(list(data.keys())[0])")
echo "$OUTPUT"

# Pass the Model UID via an environment variable
export XINFERENCE_LLM_MODEL_UID=$(echo "$OUTPUT")

echo "Model lanched The model UID is: ${XINFERENCE_LLM_MODEL_UID}"

# Start Streamlit app
poetry run streamlit run app/main.py --server.port 8501 --server.address 0.0.0.0 &

# Keep the script running
wait