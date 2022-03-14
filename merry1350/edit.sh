#!/usr/bin/env bash

ID=$1

echo "Switching to gcloud project merry1350"
echo "editing merry1350 instance $ID"

gcloud config set project merry1350

echo "Pull the file"
BUCKET="${ID}$(if [[ $ID == "" ]]; then echo ""; else echo "-"; fi)merry1350-bucket.michael-grace.uk"
gsutil cp gs://$BUCKET/scores.json scores.json
cp scores.json scores.json.backup

# Edit the File
vim scores.json

echo "Uploading the File"
gsutil cp scores.json gs://$BUCKET/

echo "Best of luck hoping the instances pick it up - for now just go delete them"
# TODO - automate that