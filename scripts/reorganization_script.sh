#!/bin/bash

# Verifie si on a bien le parametre requis
if [ $# -ne 1 ]; then
  echo "Commande attendue: $0 <repo_name>"
  echo "  <repo_name> : Nom du répertoire source"
  exit 1
fi

# Nom de la bucket S3
bucket_name="projet-shell"

# Récupération du répertoire source
source_dir="$1"

# Vérifie que le répertoire source existe sur S3
if ! aws s3 ls "s3://$bucket_name/$source_dir/" | grep -q .; then
  echo "Erreur : le répertoire '$source_dir' n'existe pas sur S3."
  exit 1
fi

echo "Réorganisation des fichiers dans le repertoire '$source_dir'"

# Copier le repertoire source depuis S3
aws s3 cp "s3://$bucket_name/$source_dir/" "$source_dir" --recursive

# Supprimer le répertoire source sur S3
aws s3 rm "s3://$bucket_name/$source_dir/" --recursive

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
  new_name="${minute}${second}${millisec}.dat"

  # Nouveau chemin complet
  new_filepath="$dest_dir/$new_name"

  # Ajout des infos dans le fichier
  {
    echo "$filename"
    echo "$(realpath "$file_path")"
    echo "creation_script.sh"
    cat "$file_path"
  } > "$new_filepath"

  # Suppression de l'ancien fichier
  rm "$file_path"

  # Permissions (lecture, écriture) propriétaire
  chmod 600 "$new_filepath"
done

# Uploader le répertoire source sur S3
aws s3 cp "$source_dir" "s3://$bucket_name/$source_dir/" --recursive

# Supprimer le repertoire en local
rm -r "$source_dir"

echo "Réorganisation terminée dans '$source_dir'"