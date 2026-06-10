# Suivi des participations olympiques

## Contexte

Le **Suivi des participations olympiques** est une application conçue pour
enregistrer et analyser la participation des pays aux Jeux olympiques. Elle
présente des statistiques sur les médailles obtenues par chaque pays afin de
mieux comprendre leurs performances historiques. L'application étant encore à
un stade précoce de son développement, l'objectif est de créer un outil robuste
et simple d'utilisation pour les passionnés des Jeux olympiques.

## Contexte technique

L'application utilise **Angular 20.3** et s'appuie sur **npm** pour la gestion
des paquets. Angular fournit le framework nécessaire à la création d'une
application web dynamique, tandis que npm simplifie la gestion des dépendances
et des scripts.

Versions testées :

- **Node.js** : 20.11.0
- **npm** : 10.2.4
- **NGINX** : 1.27

## Démarrage

### Installer les dépendances

Pour le développement local, exécutez `npm i` afin d'installer les dépendances
Node.js. Dans un environnement d'intégration continue, utilisez de préférence
`npm ci`. Le dossier du cache npm peut également être placé dans le répertoire
de travail :

```bash
npm ci --cache .npm --prefer-offline
```

## Serveur de développement

Exécutez `ng serve`, puis ouvrez `http://localhost:4200/`. L'application se
recharge automatiquement après toute modification d'un fichier source.

### Build

Exécutez `npm run build` pour construire le projet. Les fichiers générés sont
placés dans le dossier `dist/`.

### Tests

Pour exécuter les tests et vérifier le fonctionnement de l'application :

```bash
npm test
```

La suite de tests couvre les composants essentiels afin de garantir la
stabilité et la fiabilité de l'application.

### Empaquetage

Pour créer un paquet distribuable :

```bash
npm pack
```

Cette commande génère un paquet contenant le code compilé et les ressources
nécessaires.

## Étape 2 - Conteneurisation avec Docker

L'application utilise une image Docker multi-stage :

1. `node:20.19-alpine` installe les dépendances avec `npm ci` et exécute le
   build Angular de production ;
2. `nginx:1.27-alpine` reçoit uniquement les fichiers statiques compilés et les
   sert sur le port `80`.

Cette séparation garde les outils de compilation et `node_modules` hors de
l'image finale.

### État de validation

L'Étape 2 a été validée localement le 10 juin 2026 :

- build Angular dans l'étape Node réussi ;
- création de l'image finale NGINX réussie ;
- démarrage avec `docker compose up -d --build` réussi ;
- healthcheck Docker passé à l'état `healthy` ;
- page principale `http://localhost/` : HTTP `200` ;
- asset `http://localhost/assets/mock/olympic.json` : HTTP `200` ;
- route Angular directe : HTTP `200` grâce au fallback NGINX ;
- nettoyage avec `docker compose down --remove-orphans` vérifié.

### Fichiers Docker

| Fichier | Rôle |
|---|---|
| `Dockerfile` | Build Angular puis création de l'image NGINX |
| `docker-compose.yml` | Construction et exécution du frontend seul |
| `.dockerignore` | Réduction du contexte envoyé au démon Docker |
| `nginx/nginx.conf` | Service des fichiers statiques et routes Angular |

### Dossier de sortie Angular

`angular.json` définit la base de sortie suivante :

```text
dist/olympic-games-starter
```

Le builder `@angular/build:application` place les fichiers destinés au
navigateur dans :

```text
dist/olympic-games-starter/browser
```

Le `Dockerfile` copie donc précisément ce dossier vers `/app` dans l'image
NGINX.

### Construire et démarrer

Depuis la racine du frontend :

```bash
docker compose up -d --build
```

Le service est ensuite accessible à l'adresse :

```text
http://localhost
```

Contrôler la page principale et une ressource statique :

```bash
curl http://localhost/
curl http://localhost/assets/mock/olympic.json
```

### Vérifier l'état

```bash
docker compose ps
docker compose logs
```

Le service Compose possède un healthcheck HTTP. Après son démarrage,
`docker compose ps` doit afficher l'état `healthy`.

### Arrêter et nettoyer

```bash
docker compose down --remove-orphans
```

Cette commande arrête le conteneur et supprime le réseau Compose. L'image reste
dans le cache Docker pour accélérer les prochains démarrages.

Pour supprimer également l'image construite :

```bash
docker compose down --rmi local --remove-orphans
```

### Routage Angular

La directive NGINX suivante renvoie `index.html` lorsqu'une URL ne correspond
pas à un fichier physique :

```nginx
try_files $uri $uri/ /index.html;
```

Elle permet d'ouvrir ou de rafraîchir directement une route gérée par Angular
sans recevoir une erreur HTTP 404 de NGINX.

### Cache et compression

La configuration NGINX :

- active gzip pour JavaScript, JSON, CSS et les polices ;
- évite le cache durable de `index.html` ;
- applique un cache long aux bundles Angular dont le nom contient un hash.

### Résultat attendu

L'Étape 2 est validée lorsque :

- `docker compose build` termine sans erreur ;
- le conteneur passe à l'état `healthy` ;
- `http://localhost/` retourne un statut HTTP `2xx` ;
- `http://localhost/assets/mock/olympic.json` retourne un statut HTTP `2xx` ;
- l'application s'affiche dans le navigateur ;
- `docker compose down --remove-orphans` nettoie le conteneur et le réseau.

### Dépannage Docker

Si le port `80` est déjà occupé :

```bash
docker ps --filter publish=80
```

Il est également possible de publier temporairement un autre port en modifiant
la section `ports` :

```yaml
ports:
  - "8081:80"
```

L'application devient alors accessible sur `http://localhost:8081`.

Si le build ne trouve pas les fichiers Angular, vérifiez simultanément :

- `outputPath` dans `angular.json` ;
- le sous-dossier `browser` produit par le builder ;
- le chemin de la commande `COPY --from=build` dans le `Dockerfile`.

### Publication dans le registre GitLab

Pour publier l'application dans un registre GitLab :

1. **Modifiez le scope de l'application.**

   Adaptez-le à votre nouveau groupe GitLab. Par exemple, si l'URL du dépôt est
   `https://gitlab.com/your-gitlab-group-slug/olympic-games-starter`, remplacez
   le nom de l'application par
   `@your-gitlab-group-slug/olympic-games-starter` :

   ```json
   {
     "name": "@your-gitlab-group-slug/olympic-games-starter",
     ...
   }
   ```

2. **Créez un fichier `.npmrc` avec le contenu suivant :**

   ```ini
   @your-gitlab-group-slug:registry=https://gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}/packages/npm/
   //gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}/packages/npm/:_authToken="${GITLAB_TOKEN}"
   ```

3. **Définissez les variables d'environnement :**
   - `GITLAB_PROJECT_ID` : identifiant du projet GitLab ;
   - `GITLAB_TOKEN` : jeton de déploiement GitLab.

4. **Exécutez la commande de publication :**

   ```bash
   npm publish
   ```

Le paquet est alors publié dans le registre GitLab.
