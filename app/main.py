from langchain.callbacks import StreamlitCallbackHandler
from engine import ChatEngine

import tempfile
import streamlit as st 
import logging
import sys
import os

logging.basicConfig(stream=sys.stdout, level=logging.INFO)

def init_page():
    st.set_page_config(
        page_title="PDF Chatbot with Local LLM and Embeddings",
        page_icon="🤗"
    )
    st.header("PDF Chatbot with Local LLM and Embeddings")
    st.sidebar.title("Options")    


def init_message_history():
    clear_button = st.sidebar.button("Clear Conversation", key="clear")
    if clear_button or "messages" not in st.session_state:
        st.session_state.messages = [
            {"role": "assistant", "content": "Hi, I'm a chatbot. How can I help you?"}
        ]

def init_chatbot(uploaded_file):
    if not st.session_state.get("chatbot", False):
        with st.spinner("Processing..."):
            temp_dir = tempfile.mkdtemp()
            file_path = os.path.join(temp_dir, uploaded_file.name)
            with open(file_path, 'wb') as f:
                f.write(uploaded_file.getvalue())

            logging.info(f"File {uploaded_file.name} has been written to {file_path}")

            st.session_state["chatbot"] = ChatEngine(file_path)
    return st.session_state["chatbot"]


def handle_uploaded_file():
    uploaded_file = st.file_uploader("Upload your PDF", type=['pdf'])
    if uploaded_file is not None:
        return uploaded_file
    else:
        st.warning("Please upload a PDF file")
        st.stop()

def main():
    init_page()
    init_message_history()

    if uploaded_file := handle_uploaded_file():
    
        chatbot = init_chatbot(uploaded_file)

        if chatbot:
            for msg in st.session_state.messages:
                st.chat_message(msg["role"]).write(msg["content"])

            if prompt := st.chat_input(placeholder=f"Hello ! Ask me anything about {uploaded_file.name} 🤗"):
                st.session_state.messages.append({"role": "user", "content": prompt})
                st.chat_message("user").write(prompt)

                with st.chat_message("assistant"):
                    with st.spinner("Thinking..."):
                        st_cb = StreamlitCallbackHandler(st.container(), expand_new_thoughts=False)
                        response = chatbot.conversational_chat(prompt, st_cb)
                        st.session_state.messages.append({"role": "assistant", "content": response})
                        st.write(response)


if __name__ == "__main__":
    main()