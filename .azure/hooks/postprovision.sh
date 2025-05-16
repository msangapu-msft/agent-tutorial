#!/bin/bash
echo "Deploying broken branch to deployment slot..."

az webapp deployment source config \
  --name my-sre-app \
  --resource-group my-app-service-group \
  --slot broken \
  --repo-url https://github.com/msangapu-msft/agent-tutorial \
  --branch broken \
  --manual-integration
