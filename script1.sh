#!/bin/bash

# Verifie si on a bien 4 arguments
if [ $# -ne 4 ]; then
  echo "Parametres attendus: $0 <repo_name> <prefix> <N> <M>"
  echo "  <repo_name> : Nom du repo"
  echo "  <prefix> : Nom du prefix"
  echo "  <N>      : nombre de fichiers a creer"
  echo "  <M>      : ecart en millisecondes"
  exit 1
fi

# Recuperation des parametres
repo=$1       # Nom du repertoire
prefix=$2       # Nom du prefix
N=$3            # Nombre de fichiers
M=$4            # ecart en millisecondes


# Creer le dossier de sortie
folder_name="${repo}"
mkdir -p "$folder_name"

echo "Creation de $N fichiers dans le dossier '$folder_name' avec un delai de $M ms"


# Boucle de creation des fichiers
for ((i=0; i<N; i++)); do
  # Genere un timestamp avec millisecondes
  timestamp=$(date +"%Y-%m-%d-%H-%M-%S-")$(date +"%3N")

  # Creer le nom du fichier
  filename="${prefix}_${timestamp}.txt"

  # Creer le fichier vide
  touch "$folder_name/$filename"
  echo "Fichier $((i + 1)) créer : $filename"

  # Pause apres la creation de chaque fichier
  if [ $i -lt $((N - 1)) ]; then
    sleep_time="${M}e-3"
    sleep "$sleep_time"
    echo "sleep_time : $sleep_time"
  fi

done

echo "Fichier créer avec succés !"







