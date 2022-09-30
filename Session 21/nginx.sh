az appservice plan create -n nginxAppServicePlan -g session21 --is-linux
az webapp create -g session21 -p nginxAppServicePlan -n nginx --deployment-container-image-name capgemacr3.azurecr.io/nginx
az webapp config container set -n nginx -g session21 --docker-custom-image-name capgemacr3.azurecr.io/nginx --docker-registry-server-url https://capgemacr3.azurecr.io