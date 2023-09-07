# PDF Chatbot with Local LLM and Embeddings


## Deployment

1. Clone the repo

2. You can run the docker-compose command to launch the app with docker containers, and then type a question in the chat interface.


```
docker-compose up --build
```


## Run the app

In you want to run a local dev environment, the following command will let you test the application with OpenAI API.

```
LLM=openai streamlit run ./app/main.py
```


## Troubleshooting

* If you want to use OpenAI, check that you've created an .env file that contains your valid (and working) API keys.
* Make sure you have install [nvidia-container-runtime](https://github.com/nvidia/nvidia-container-runtime#docker-engine-setup)


