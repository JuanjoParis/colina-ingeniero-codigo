#!/bin/bash

# ================================
# ⚡ Script para crear Colina: Ingeniero de Código
# ================================

# 📌 Verifica si Git está configurado
if ! command -v git &> /dev/null; then
    echo "❌ Git no está instalado. Por favor, instálalo antes de continuar."
    exit 1
fi

# 📌 Verifica si Python está instalado
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 no está instalado. Por favor, instálalo antes de continuar."
    exit 1
fi

# ✅ Variables del Proyecto
REPO_NAME="colina-ingeniero-codigo"
GITHUB_USER="JuanjoParis"
GITHUB_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"

# 🔹 Clonar el repositorio si no existe
if [ ! -d "$REPO_NAME" ]; then
    echo "📥 Clonando el repositorio desde GitHub..."
    git clone $GITHUB_URL
    cd $REPO_NAME
else
    cd $REPO_NAME
fi

# 🏗️ Crear estructura de carpetas
echo "📂 Creando estructura del proyecto..."
mkdir -p backend frontend

# 🚀 Crear archivos esenciales
echo "📝 Creando archivos base..."

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
    return {"response": response["choices"][0]["message"]["content"]}
EOL

cat > backend/requirements.txt <<EOL
fastapi
uvicorn
openai
python-dotenv
EOL

cat > backend/Dockerfile <<EOL
FROM python:3.10
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
EOL

cat > frontend/app.py <<EOL
import streamlit as st
import requests

st.title("Colina: Ingeniero de Código")

prompt = st.text_area("Escribe tu consulta:")

if st.button("Generar"):
    response = requests.post("http://localhost:8000/generate/", json={"prompt": prompt})
    st.write(response.json().get("response"))
EOL

cat > frontend/requirements.txt <<EOL
streamlit
requests
EOL

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

cat > .env <<EOL
OPENAI_API_KEY=tu-api-key
EOL

cat > README.md <<EOL
# Colina: Ingeniero de Código 🛠️

Un asistente de ingeniería de software basado en IA, optimizado para análisis, seguridad y automatización.

## 🚀 Instalación y Uso

1. Clona este repositorio:
   \`\`\`sh
   git clone $GITHUB_URL
   cd $REPO_NAME
   \`\`\`

2. Configura las dependencias:
   \`\`\`sh
   cd backend && pip install -r requirements.txt
   cd ../frontend && pip install -r requirements.txt
   \`\`\`

3. Carga las variables de entorno en \`.env\`:
   \`\`\`
   OPENAI_API_KEY=tu-api-key
   \`\`\`

4. Ejecuta el backend:
   \`\`\`sh
   cd backend
   uvicorn main:app --host 0.0.0.0 --port 8000 --reload
   \`\`\`

5. Ejecuta el frontend:
   \`\`\`sh
   cd frontend
   streamlit run app.py
   \`\`\`
EOL

# ✅ Instalar dependencias
echo "📦 Instalando dependencias..."
cd backend && pip install -r requirements.txt && cd ..
cd frontend && pip install -r requirements.txt && cd ..

# ✅ Subir cambios a GitHub
echo "🚀 Subiendo archivos a GitHub..."
git add .
git commit -m "Subiendo código inicial de Colina: Ingeniero de Código"
git push origin main

echo "✅ Todo listo. Ahora puedes ejecutar el backend y el frontend."
echo "🔹 Para iniciar el backend: cd backend && uvicorn main:app --host 0.0.0.0 --port 8000 --reload"
echo "🔹 Para iniciar el frontend: cd frontend && streamlit run app.py"
echo "🌍 Abre en tu navegador: http://localhost:8501"
