TAG = v1

docker:
	docker build -t pg-controller:$(TAG) .; 
	docker tag pg-controller:$(TAG) guptaarvindk/pg-controller:$(TAG);

push: docker
	docker push guptaarvindk/pg-controller:$(TAG)
