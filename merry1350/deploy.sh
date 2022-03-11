#!/usr/bin/env bash

NEW_ID=$1

echo "Switching to gcloud project merry1350"
echo "Creating merry1350 instance ${NEW_ID}"

gcloud config set project merry1350

echo "Cloning Repo"
git clone https://github.com/michael-grace/the-merry-time.git $NEW_ID
cd $NEW_ID

echo "Updating app.yaml"
NEW_BUCKET="${NEW_ID}-merry1350-bucket.michael-grace.uk"
sed -i "s/service: .*/service: ${NEW_ID}/" app.yaml
sed -i "s/GCLOUD_STORAGE_BUCKET: .*/GCLOUD_STORAGE_BUCKET: ${NEW_BUCKET}/" app.yaml

echo "Creating bucket and uploading empty file"
gsutil mb -c STANDARD -l EUROPE-WEST2 -b on gs://${NEW_BUCKET}
gsutil cp scores.json gs://${NEW_BUCKET}/

echo "Deploy the App"
gcloud app deploy

echo "Register Domain"
gcloud app domain-mappings create "${NEW_ID}.merry1350.michael-grace.uk" --certificate-management=AUTOMATIC 

echo "Update and deploy dispatch file"
cd ..
echo "  - url: ${NEW_ID}.merry1350.michael-grace.uk/*" >> dispatch.yaml
echo "    service: ${NEW_ID}" >> dispatch.yaml
gcloud app deploy dispatch.yaml

echo "Done - https://${NEW_ID}.merry1350.michael-grace.uk"
echo "dispatch.yaml file should be committed"


