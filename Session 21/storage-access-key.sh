ACCOUNT_KEY=$(az storage account keys list --resource-group session21 --account-name capgemtfstate --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY