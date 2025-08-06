# TP Linux/ Shell


L'objectif de ce TP est de créer des scripts Shell pour automatiser la **création**, la **réorganisation** et le **transfert vers AWS S3** de fichiers, en respectant une structure temporelle et arborescence précise.

### Les scripts

- **creation_script.sh** : crée un répertoire avec N fichiers, chaque M millisecondes.
- **reorganization_script.sh** : réorganise les fichiers en arborescence temporelle.
- **main.sh** : script d’orchestration : exécute les 2 scripts ci-dessus dans l’ordre.


### Objectifs demandés

 1- Création de fichiers: Créer un repertoire qui contient N fichiers nommée avec un préfixe et un timestamp : "prefix_year-month-day-hour-minute-second-millisecond.txt".

 Exemple : 
 
 `./creation_script.sh repo_devops git 2 2`

 Crée 2 fichiers avec un intervale de 2 ms et un prefix "git" dans le repertoire "repo_devops" : git_2023-06-29-12-42-19-64.txt et git_2023-06-29-12-45-01-34.txt
 
 2- Réorganisation du repertoire: réorganiser les fichiers créer en suivante l'oborescence suivante.

 Exemple : 
 
 La réorganisation de ces 2 fichiers:  `git_2023-06-29-12-42-19-64.txt ` et  `git_2023-06-29-12-45-01-34.txt ` devra suivre cette arborescence:

 ![Diagramme](images/arborescence.png)

