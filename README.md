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

La documentation de l'étape de conteneurisation avec Docker est centralisée
dans
[`msm-projet-06-ops/docs/etape-1.2-conteneurisation-frontend.md`](https://github.com/msm-oc-projects/msm-projet-06-ops/blob/main/docs/etape-1.2-conteneurisation-frontend.md).

## Publication dans GitHub Packages

Le paquet npm utilise le scope de l'organisation GitHub :

```json
{
  "name": "@msm-oc-projects/olympic-games-starter"
}
```

Le workflow GitHub Actions publie automatiquement le paquet après la création
d'une version par semantic-release. Il utilise `GITHUB_TOKEN` avec la
permission `packages: write`.

Pour une publication manuelle, créez un fichier `.npmrc` local :

```ini
@msm-oc-projects:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=${NODE_AUTH_TOKEN}
```

Définissez ensuite un Personal Access Token GitHub autorisé à écrire dans les
packages :

```bash
export NODE_AUTH_TOKEN=votre-token
npm ci
npm publish
```

Le fichier `.npmrc` contenant un token ne doit jamais être versionné.
