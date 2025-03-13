import streamlit as st
import requests

st.title("Colina: Ingeniero de Código")

prompt = st.text_area("Escribe tu consulta:")

if st.button("Generar"):
    response = requests.post("http://localhost:8000/generate/", json={"prompt": prompt})
    st.write(response.json().get("response"))
