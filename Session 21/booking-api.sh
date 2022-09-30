az appservice plan create -g session21 -n booking-api-plan --sku F1
az webapp create -g session21 -p booking-api-plan -n booking-api-capgem -i herbertmoore/static-website-01:booking-api -s herbertmoore

az sql server create -l westeurope -g session21 -n capgemsql2019 -u saturn -p Qwerty12!
az sql db create -g session21 -s capgemsql2019 -n Booking-DB

az webapp connection create sql -g session21 -n booking-api-capgem --tg session21 --server capgemsql2019 --database Booking-DB --query configurations

az webapp config appsettings set -g session21 -n booking-api-capgem --settings "@appsettings.Development.json"