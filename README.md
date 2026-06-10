# Suivi des participations olympiques

## Contexte

Le **Suivi des participations olympiques** est une application conçue pour
enregistrer et analyser la participation des pays aux Jeux olympiques. Elle
présente des statistiques sur les médailles obtenues par chaque pays afin de
mieux comprendre leurs performances historiques. L'application étant encore à
un stade précoce de son développement, l'objectif est de créer un outil robuste
et simple d'utilisation pour les passionnés des Jeux olympiques.

## Contexte technique

L'application utilise **Angular 14.1** et s'appuie sur **npm** pour la gestion
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

### Déploiement avec NGINX

Pour déployer l'application sur un serveur web NGINX avec Docker, utilisez la
configuration située dans le dossier `nginx`. Elle définit `/app` comme dossier
racine de l'application.

Après le build, copiez le dossier `dist/olympic-games-starter` dans le dossier
racine de l'application au sein de l'image Docker.

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
