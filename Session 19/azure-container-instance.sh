#!/bin/bash

az container create --resource-group build-agents-templates --name capgemcontainerinstance --image capgemacr2.azurecr.io/shellscript:latest --cpu 1 --memory 1 --registry-login-server capgemacr2.azurecr.io --registry-username 04e31bc6-ac3b-4b22-a91f-9c4149c8cd4b