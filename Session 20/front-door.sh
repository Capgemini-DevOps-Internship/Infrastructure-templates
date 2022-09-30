az afd profile create -g globally-distributed-systems --profile-name capgemFrontDoor --sku Standard_AzureFrontDoor

az afd endpoint create -g globally-distributed-systems --endpoint-name endpoint1 --profile-name capgemFrontDoor --enabled-state Enabled

az afd origin-group create -g globally-distributed-systems --origin-group-name capgemog --profile-name capgemFrontDoor --probe-request-type GET --probe-protocol Http --probe-interval-in-seconds 120 --probe-path / --sample-size 4 --successful-samples-required 3 --additional-latency-in-milliseconds 50

az afd origin create -g globally-distributed-systems --host-name host-1.azurewebsites.net --profile-name capgemFrontDoor --origin-group-name capgemog --origin-name origin1 --origin-host-header host-1.azurewebsites.net --priority 1 --weight 500 --enabled-state Enabled  --https-port 443
az afd origin create -g globally-distributed-systems --host-name host-2.azurewebsites.net --profile-name capgemFrontDoor --origin-group-name capgemog --origin-name origin2 --origin-host-header host-2.azurewebsites.net --priority 1 --weight 500 --enabled-state Enabled  --https-port 443
az afd origin create -g globally-distributed-systems --host-name dr-1.azurewebsites.net --profile-name capgemFrontDoor --origin-group-name capgemog --origin-name origin3 --origin-host-header dr-1.azurewebsites.net --priority 5 --weight 500 --enabled-state Enabled  --https-port 443

az afd route create -g globally-distributed-systems --endpoint-name endpoint1 --profile-name capgemFrontDoor --route-name route1 --https-redirect Enabled --origin-group capgemog --supported-protocols Https --link-to-default-domain Enabled --forwarding-protocol HttpsOnly