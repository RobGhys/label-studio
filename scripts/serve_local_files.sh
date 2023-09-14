#!/usr/bin/env bash

# Get the arguments from command line
ROOT_DIR=$1
WILDCARD=${2:-"*"}
PORT=${3:-3000}

# Vérification et instructions
echo "Usage: sh serve_local_files.sh ROOT_DIR WILDCARD PORT"
echo "This script scans INPUT_DIR directory with WILDCARD filter [all files by default],"
echo "ROOT_DIR : Root Directory containing sub-directories with images"
echo "WILDCARD : Filters pour les types de fichiers à servir [default = *]"
echo "Starts web server on the port PORT [3000 by default] that serves files from INPUT_DIR with CORS enabled"
echo "Generates output files"
echo

# Loop through sub-directories
for SUB_DIR in $ROOT_DIR/*; do
  if [ -d "$SUB_DIR" ]; then
    # Get sub-directory name and prepare txt file name
    SUB_DIR_NAME=$(basename $SUB_DIR)
    OUTPUT_FILE="${SUB_DIR_NAME}.txt"

    echo "Scan sub-directory: ${SUB_DIR_NAME} ..."

    # Find image files and create txt file
    FIND_CMD="find ${SUB_DIR} -type f -name ${WILDCARD}"
    INPUT_DIR_ESCAPED=$(printf '%s\n' "$SUB_DIR" | sed -e 's/[\/&]/\\&/g')
    eval $FIND_CMD | sed "s|${INPUT_DIR_ESCAPED}|http://localhost:${PORT}/${SUB_DIR_NAME}|g" > $OUTPUT_FILE

    echo "Created txt file : ${OUTPUT_FILE}"
  fi
done

# Démarrage du serveur web
echo "Run web server on port ${PORT} with CORS enabled"
cd $ROOT_DIR
http-server -p $PORT --cors