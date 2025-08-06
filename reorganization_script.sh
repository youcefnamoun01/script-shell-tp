#!/bin/bash

# Verifie si on a bien le parametre requis
if [ $# -ne 1 ]; then
  echo "Commande attendue: $0 <repo_name>"
  echo "  <repo_name> : Nom du répertoire source"
  exit 1
fi

# Nom de la bucket S3
bucket_name="projet-shell"

# Récupération du nom du répertoire source
source_dir="$1"

# Copier le repertoire source depuis S3
aws s3 cp "s3://$bucket_name/$source_dir/" "$source_dir" --recursive

# Supprimer le répertoire source sur S3
aws s3 rm "s3://$bucket_name/$source_dir/" --recursive

# Vérifie que le répertoire source existe
if [ ! -d "$source_dir" ]; then
  echo "Erreur : le répertoire '$source_dir' n'existe pas."
  exit 1
fi


# Parcours tous les fichiers
for file_path in "$source_dir"/*.txt; do
 [ -e "$file_path" ] || continue
  filename=$(basename "$file_path")
  prefix=$(echo "$filename" | cut -d'_' -f1)
  date_part=$(echo "$filename" | cut -d'_' -f2 | sed 's/.txt//')

  # Extraction des composants de la date
  year=$(echo "$date_part" | cut -d'-' -f1)
  month=$(echo "$date_part" | cut -d'-' -f2)
  day=$(echo "$date_part" | cut -d'-' -f3)
  hour=$(echo "$date_part" | cut -d'-' -f4)
  minute=$(echo "$date_part" | cut -d'-' -f5)
  second=$(echo "$date_part" | cut -d'-' -f6)
  millisec=$(echo "$date_part" | cut -d'-' -f7)

  # Nouveau repertoire de destination
  dest_dir="$source_dir/$prefix/$year/$month/$day/$hour"
  mkdir -p "$dest_dir"

  # Nouveau nom de fichier
  new_name="${minute}${second}${millisec}.txt"


  # Déplacement et renommage
  mv "$file_path" "$dest_dir/$new_name"

  # Permissions
  chmod 600 "$dest_dir/$new_name"
done

aws s3 cp "$source_dir" "s3://$bucket_name/$source_dir/" --recursive
echo "Réorganisation terminée dans '$source_dir'."
