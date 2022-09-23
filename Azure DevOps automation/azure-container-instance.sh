#!/bin/bash

az container create -g build-agents-templates --name CapgemContainer

az container exec -g build-agents-templates --container-name CapgemContainer --exec-command "azure-container-shellscript.sh"