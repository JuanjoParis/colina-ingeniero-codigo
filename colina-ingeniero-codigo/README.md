# Colina: Ingeniero de Código 🛠️

Un asistente de ingeniería de software basado en IA, optimizado para análisis, seguridad y automatización.

## 🚀 Instalación y Uso

1. Clona este repositorio:
   ```sh
   git clone https://github.com/JuanjoParis/colina-ingeniero-codigo.git
   cd colina-ingeniero-codigo
   ```

2. Configura las dependencias:
   ```sh
   cd backend && pip install -r requirements.txt
   cd ../frontend && pip install -r requirements.txt
   ```

3. Carga las variables de entorno en `.env`:
   ```
   OPENAI_API_KEY=tu-api-key
   ```

4. Ejecuta el backend:
   ```sh
   cd backend
   uvicorn main:app --host 0.0.0.0 --port 8000 --reload
   ```

5. Ejecuta el frontend:
   ```sh
   cd frontend
   streamlit run app.py
   ```
