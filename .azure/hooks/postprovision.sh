#!/usr/bin/env bash
set -e

echo "📦 Zipping source code from ./src for deployment to the 'broken' slot..."

# Create the zip archive from ./src
zip -r slot-deploy.zip ./src > /dev/null

# Retrieve environment values (injected by azd)
APP_NAME=$(azd env get-values --output json | jq -r '.APP_NAME // "my-sre-app"')
RESOURCE_GROUP=$(azd env get-values --output json | jq -r '.AZURE_RESOURCE_GROUP // "rg-my-sre-app-env"')
SLOT_NAME="broken"

echo "🚀 Deploying to slot '$SLOT_NAME' on app '$APP_NAME' in resource group '$RESOURCE_GROUP'..."

az webapp deployment source config-zip \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME" \
  --slot "$SLOT_NAME" \
  --src slot-deploy.zip

echo "✅ Slot deployment complete."
