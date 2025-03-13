from fastapi import FastAPI
import os
import openai

app = FastAPI()
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "tu-api-key")

@app.get("/")
def read_root():
    return {"message": "Colina: Ingeniero de Código está activo"}

@app.post("/generate/")
def generate_code(prompt: str):
    response = openai.ChatCompletion.create(
        model="gpt-4-turbo",
        messages=[{"role": "system", "content": "Eres un ingeniero de software de élite."},
                  {"role": "user", "content": prompt}]
    )
    return {"response": response["choices"][0]["message"]["content"]}
