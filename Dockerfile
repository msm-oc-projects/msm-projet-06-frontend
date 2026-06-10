# Étape de construction : l'image Node contient npm et Angular CLI via les
# dépendances locales du projet. Elle ne sera pas conservée dans l'image finale.
FROM node:20.19-alpine AS build

# Tous les fichiers de travail sont isolés dans un dossier dédié.
WORKDIR /workspace

# Copier les manifestes avant le code permet à Docker de réutiliser la couche
# `npm ci` tant que package.json et package-lock.json ne changent pas.
COPY package*.json ./

# `npm ci` installe exactement les versions verrouillées dans package-lock.json.
# Le cache local réduit les téléchargements lors des builds suivants.
RUN npm ci --cache .npm --prefer-offline

# Le contexte est filtré par .dockerignore : node_modules, dist, rapports et
# fichiers locaux ne sont donc pas envoyés au démon Docker.
COPY . .

# La configuration Angular utilise le mode production par défaut. Avec le
# builder Angular actuel, les fichiers web sont générés dans le sous-dossier
# dist/olympic-games-starter/browser.
RUN npm run build

# Étape d'exécution : seule l'image NGINX légère et les fichiers compilés sont
# conservés. Node.js et les dépendances de développement restent hors de
# l'image finale.
FROM nginx:1.27-alpine

# Cette configuration sert l'application depuis /app et redirige les routes
# Angular vers index.html pour prendre en charge le routage côté navigateur.
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Le chemin doit rester cohérent avec `outputPath` dans angular.json.
COPY --from=build /workspace/dist/olympic-games-starter/browser /app

# Documentation du port écouté par NGINX. La publication sur la machine hôte
# est définie dans docker-compose.yml.
EXPOSE 80

