#!/bin/bash

# Verifie si on a bien 4 parametres
if [ $# -ne 4 ]; then
  echo "Commande attendue: $0 <repo_name> <prefix> <N> <M>"
  echo "  <repo_name> : Nom du repo"
  echo "  <prefix>    : Nom du prefix"
  echo "  <N>         : nombre de fichiers"
  echo "  <M>         : Ecart en millisecondes"
  exit 1
fi

# Recuperation des parametres
repo=$1         # Nom du repertoire
prefix=$2       # Nom du prefix
N=$3            # Nombre de fichiers
M=$4            # Ecart en millisecondes

# Nom de la bucket S3
bucket_name="projet-shell"

# Creation du repertoire
folder_name="${repo}"
mkdir -p "$folder_name"

echo "Creation de $N fichiers dans le repertoire '$folder_name' avec un delai de $M ms"


# Boucle de creation des fichiers
for ((i=0; i<N; i++)); do

  # Generer un timestamp avec millisecondes
  timestamp=$(date +"%Y-%m-%d-%H-%M-%S-")$(date +"%3N")

  # Creer le nom du fichier
  filename="${prefix}_${timestamp}.txt"

  # Creer le fichier vide
  touch "$folder_name/$filename"

  echo "Fichier $((i + 1)) créer : $filename"
  
  # Uploder sur S3
  aws s3 cp "$folder_name/$filename" "s3://$bucket_name/$folder_name/$filename"

  # Pause apres la creation de chaque fichier
  if [ $i -lt $((N - 1)) ]; then
    sleep_time="${M}e-3"
    sleep "$sleep_time"
  fi

done

# Supprimer le repertoire en local
rm -r "$folder_name"

echo "Creation des fichiers terminée dans '$folder_name'"






