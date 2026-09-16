# --- Stage 1 : Build de l'application React avec Node 22 ---
FROM node:22-alpine AS build

WORKDIR /app

# Copie des fichiers de dépendances
COPY package*.json ./

# Installation des dépendances
RUN npm ci

# Copie du reste du code source
COPY . .

# Compilation du projet Vite (génère le dossier /app/dist)
RUN npm run build


# --- Stage 2 : Service des fichiers statiques avec Nginx ---
FROM nginx:alpine

# Copie du build HTML/JS/CSS généré depuis le stage 1 vers Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Exposition du port 80
EXPOSE 80

# Commande de démarrage par défaut de Nginx
CMD ["nginx", "-g", "daemon off;"]
