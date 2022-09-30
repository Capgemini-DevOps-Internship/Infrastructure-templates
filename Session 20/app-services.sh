az appservice plan create -g globally-distributed-systems -n host-1-plan -l westeurope
az webapp up -n host-1 -g globally-distributed-systems -l westeurope -p host-1-plan --html
az webapp update -n host-1 -g globally-distributed-systems --https-only false

az appservice plan create -g globally-distributed-systems -n host-2-plan -l northeurope
az webapp up -n host-2 -g globally-distributed-systems -l northeurope -p host-2-plan --html
az webapp update -n host-2 -g globally-distributed-systems --https-only false

az appservice plan create -g globally-distributed-systems -n dr-plan -l francecentral
az webapp up -n dr-1 -g globally-distributed-systems -l francecentral -p dr-plan --html
az webapp update -n dr-1 -g globally-distributed-systems --https-only false