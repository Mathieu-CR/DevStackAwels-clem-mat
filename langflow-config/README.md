# Synchronisation Langflow

Ce script permet de synchroniser automatiquement les flows Langflow entre un dépôt Git et une instance Langflow. Il détecte les changements dans les fichiers JSON des flows et les synchronise avec l'instance Langflow, en gérant l'ajout, la modification et la suppression de flows, ainsi que leur organisation en dossiers.

## Fonctionnalités

- Détection automatique des changements dans les fichiers de flows via Git
- Ajout, modification et suppression de flows dans Langflow
- Organisation des flows en dossiers basée sur la structure des dossiers dans le dépôt
- Préservation des flows existants non modifiés dans les dossiers
- Gestion correcte de plusieurs dossiers et flows
- Suppression des dossiers vides à la fin du processus
- Support complet pour la structure de dossiers `langflow-config/flows/`
- Logs détaillés pour faciliter le débogage

## Prérequis

- Python 3.6+
- Git
- Accès à une instance Langflow
- Dépendances Python : `requests`

## Installation

1. Clonez ce dépôt ou téléchargez le script `sync_langflow.py`
2. Installez les dépendances requises :

```bash
pip install requests
```

## Utilisation

### En ligne de commande

```bash
python sync_langflow.py [--langflow-url URL] [--api-token TOKEN] [--repo-path PATH] [--before-commit COMMIT] [--after-commit COMMIT] [--verbose]
```

### Options

- `--langflow-url` : URL de l'instance Langflow (par défaut: http://localhost:7860)
- `--api-token` : Token d'API pour l'authentification Langflow
- `--repo-path` : Chemin vers le dépôt Git local (par défaut: répertoire courant)
- `--before-commit` : Commit de référence pour la comparaison (avant)
- `--after-commit` : Commit de référence pour la comparaison (après)
- `--verbose` : Active le mode verbeux pour le logging

### Variables d'environnement

Vous pouvez également configurer le script via des variables d'environnement :

- `LANGFLOW_URL` : URL de l'instance Langflow
- `LANGFLOW_API_TOKEN` : Token d'API pour l'authentification Langflow
- `REPO_PATH` : Chemin vers le dépôt Git local
- `BEFORE_COMMIT` : Commit de référence pour la comparaison (avant)
- `AFTER_COMMIT` : Commit de référence pour la comparaison (après)
- `VERBOSE` : Active le mode verbeux pour le logging (true/false)

## Intégration avec GitHub Actions

Vous pouvez intégrer ce script dans un workflow GitHub Actions pour synchroniser automatiquement les flows lorsque des modifications sont apportées au dépôt. Voici un exemple de configuration :

```yaml
name: Sync Langflow Flows

on:
  push:
    branches:
      - main
    paths:
      - 'langflow-config/flows/**'

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3
        with:
          fetch-depth: 2

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install requests

      - name: Create sync script
        run: |
          mkdir -p scripts
          cat > scripts/sync_langflow.py << 'EOL'
          # Contenu du script sync_langflow.py
          EOL
          chmod +x scripts/sync_langflow.py

      - name: Sync Langflow flows
        run: python scripts/sync_langflow.py
        env:
          LANGFLOW_URL: ${{ secrets.LANGFLOW_URL }}
          LANGFLOW_API_TOKEN: ${{ secrets.LANGFLOW_API_TOKEN }}
          BEFORE_COMMIT: ${{ github.event.before }}
          AFTER_COMMIT: ${{ github.sha }}
          REPO_PATH: ${{ github.workspace }}
```

N'oubliez pas de configurer les secrets GitHub pour `LANGFLOW_URL` et `LANGFLOW_API_TOKEN` dans les paramètres de votre dépôt.

## Structure des dossiers

Le script s'attend à ce que les flows soient organisés dans la structure de dossiers suivante :

```
langflow-config/
└── flows/
    ├── DossierA/
    │   ├── Flow1.json
    │   └── Flow2.json
    └── DossierB/
        ├── Flow3.json
        └── Flow4.json
```

Chaque dossier sous `langflow-config/flows/` sera créé comme un dossier dans Langflow, et les flows JSON qu'il contient seront ajoutés à ce dossier.

## Fonctionnement

1. Le script détecte les changements dans les fichiers de flows entre deux commits Git
2. Il traite les flows ajoutés, modifiés et supprimés
3. Il organise les flows en dossiers basés sur la structure des dossiers dans le dépôt
4. Il préserve les flows existants non modifiés dans les dossiers
5. Il supprime les dossiers vides à la fin du processus

## Dépannage

Si vous rencontrez des problèmes avec le script, activez le mode verbeux avec l'option `--verbose` ou en définissant la variable d'environnement `VERBOSE=true`. Cela affichera des logs détaillés qui peuvent aider à identifier la source du problème.

## Licence

Ce projet est sous licence MIT.
