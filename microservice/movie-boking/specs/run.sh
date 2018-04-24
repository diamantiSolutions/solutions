sed -e 's~<MONGO_RS>~cinema-rs-0.cinema-mongo:27017 cinema-rs-1.cinema-mongo:27017 cinema-rs-2.cinema-mongo:27017~g' deploy.yaml | kubectl create -f -
#sed -e 's~<MONGO_RS>~cinema-rs-0.cinema-mongo:27017~g' deploy.yaml | kubectl create -f -

