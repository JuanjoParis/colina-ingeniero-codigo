#!/bin/bash

# ================================
# ⚡ Script para Configurar y Ejecutar Colina: Ingeniero de Código
# ================================

# 📌 Verificar dependencias esenciales
echo "🔍 Verificando dependencias..."

for cmd in git python3 pip docker docker-compose; do
    if ! command -v $cmd &> /dev/null; then
        echo "❌ $cmd no está instalado. Por favor, instálalo antes de continuar."
        exit 1
    fi
done

echo "✅ Todas las dependencias están instaladas."

# ✅ Variables del Proyecto
REPO_NAME="colina-ingeniero-codigo"
GITHUB_USER="JuanjoParis"
GITHUB_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"

# 📌 Clonar el repositorio si no existe
if [ ! -d "$REPO_NAME" ]; then
    echo "📥 Clonando el repositorio desde GitHub..."
    git clone $GITHUB_URL
fi

cd $REPO_NAME

# 📌 Crear estructura de carpetas si faltan
echo "📂 Verificando estructura del proyecto..."
mkdir -p backend frontend

# 🏗️ Crear archivos esenciales si no existen
echo "📝 Verificando archivos base..."

# 🔹 Backend (FastAPI)
if [ ! -f backend/main.py ]; then
    cat > backend/main.py <<EOL
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
    return {"response": response['choices'][0]['message']['content']}
EOL
fi

if [ ! -f backend/requirements.txt ]; then
    echo -e "fastapi\nuvicorn\nopenai\npython-dotenv" > backend/requirements.txt
fi

if [ ! -f backend/Dockerfile ]; then
    cat > backend/Dockerfile <<EOL
FROM python:3.10
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
EOL
fi

# 🔹 Frontend (Streamlit)
if [ ! -f frontend/app.py ]; then
    cat > frontend/app.py <<EOL
import streamlit as st
import requests

st.title("Colina: Ingeniero de Código")

prompt = st.text_area("Escribe tu consulta:")

if st.button("Generar"):
    response = requests.post("http://localhost:8000/generate/", json={"prompt": prompt})
    st.write(response.json().get("response"))
EOL
fi

if [ ! -f frontend/requirements.txt ]; then
    echo -e "streamlit\nrequests" > frontend/requirements.txt
fi

# 🔹 Archivo .env
if [ ! -f .env ]; then
    echo "OPENAI_API_KEY=tu-api-key" > .env
fi

# 🔹 Docker Compose
if [ ! -f docker-compose.yml ]; then
    cat > docker-compose.yml <<EOL
version: "3.8"
services:
  backend:
    build: ./backend
    ports:
      - "8000:8000"
    env_file: .env
  frontend:
    build: ./frontend
    ports:
      - "8501:8501"
    depends_on:
      - backend
EOL
fi

# ✅ Instalar dependencias
echo "📦 Instalando dependencias..."
cd backend && pip install -r requirements.txt && cd ..
cd frontend && pip install -r requirements.txt && cd ..

# ✅ Subir cambios a GitHub
echo "🚀 Subiendo archivos a GitHub..."
git add .
git commit -m "Configuración y ajuste automático de Colina"
git push origin main

# ✅ Ejecutar el Proyecto
echo "🛠️ Iniciando servicios..."

# 🔹 Levantar Backend
cd backend && uvicorn main:app --host 0.0.0.0 --port 8000 --reload &
sleep 3
cd ..

# 🔹 Levantar Frontend
cd frontend && streamlit run app.py &
sleep 3
cd ..

# 🔹 Levantar Docker si está disponible
if command -v docker-compose &> /dev/null; then
    echo "🐳 Levantando servicios con Docker..."
    docker-compose up -d
fi

echo "✅ Todo listo. Abre tu navegador en:"
echo "🌍 Backend: http://localhost:8000/docs"
echo "🌍 Frontend: http://localhost:8501"
