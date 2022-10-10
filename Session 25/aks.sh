MYACR=session25

az acr create -n $MYACR -g session25 --sku standard

az aks create -n capgem-aks -g session25 -c 1 --generate-ssh-keys --attach-acr $MYACR