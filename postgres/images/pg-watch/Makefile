TAG = v1

docker:
	docker build -t pg-watch:$(TAG) .; 
	docker tag pg-watch:$(TAG) guptaarvindk/pg-watch:$(TAG);

push: docker
	docker push guptaarvindk/pg-watch:$(TAG)
