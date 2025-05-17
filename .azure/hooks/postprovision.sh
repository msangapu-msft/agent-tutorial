#!/usr/bin/env bash
set -e

echo "Zipping source code from ./src for deployment to the 'broken' slot..."
zip -r slot-deploy.zip ./src > /dev/null

# Attempt to read from azd environment
APP_NAME=$(azd env get-values --output json | jq -r '.APP_NAME // empty')
RESOURCE_GROUP=$(azd env get-values --output json | jq -r '.AZURE_RESOURCE_GROUP // empty')
SLOT_NAME="broken"

# Fallback if APP_NAME wasn't captured
if [[ -z "$APP_NAME" ]]; then
  echo "APP_NAME not found in environment. Attempting to infer from webapp in RG..."
  APP_NAME=$(az webapp list --resource-group "$RESOURCE_GROUP" --query '[0].name' -o tsv)
fi

# Fail clearly if either is still empty
if [[ -z "$APP_NAME" || -z "$RESOURCE_GROUP" ]]; then
  echo "APP_NAME or RESOURCE_GROUP is missing. Cannot deploy to slot."
  exit 1
fi

# Wait for the 'broken' slot to be ready
echo "Waiting for slot '$SLOT_NAME' to become available..."
for i in {1..10}; do
  if az webapp show --resource-group "$RESOURCE_GROUP" --name "$APP_NAME" --slot "$SLOT_NAME" &> /dev/null; then
    echo "Slot '$SLOT_NAME' is ready."
    break
  fi
  echo "⏳ Still waiting... ($i/10)"
  sleep 10
done


echo "Deploying to slot '$SLOT_NAME' on app '$APP_NAME' in resource group '$RESOURCE_GROUP'..."

az webapp deploy \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME" \
  --slot "$SLOT_NAME" \
  --src-path slot-deploy.zip \
  --type zip

echo "Slot deployment complete."
