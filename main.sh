#!/bin/bash

# Verifie si on a bien 3 parametres
if [ $# -ne 3 ]; then
  echo "Commande attendue: $0 <repo_name:[prefix1,prefix2,prefix3]> <N> <M>"
  echo "  <repo_name> : Nom du repo"
  echo "  <prefix> : Nom du prefix"
  echo "  <N>      : nombre de fichiers a creer"
  echo "  <M>      : ecart en millisecondes"
  exit 1
fi

# Recuperation des parametres
repo_prefix=$1      # Nom du repertoire et des prefixes
N=$2                # Nombre de fichiers
M=$3                # ecart en millisecondes


# Extraction du nom du repo et des prefixes
repo=$(echo "$repo_prefix" | cut -d':' -f1)
prefix=$(echo "$repo_prefix" | cut -d':' -f2)

# Extraction des prefixes
prefix_list=$(echo "$prefix" | tr -d '[] ' | tr ',' ' ')
prefix_array=($prefix_list)

# Création du répertoire et des fichiers
for prefix in "${prefix_array[@]}"; do
    ./scripts/creation_script.sh "$repo" "$prefix" "$N" "$M"
    ./scripts/reorganization_script.sh "$repo"
done

