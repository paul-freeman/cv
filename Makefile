all: cv

.PHONY: clean build-cv cv

clean:
	rm paul-freeman.pdf paul-freeman.png

build-cv:
	DOCKER_BUILDKIT=1 docker build . -t cv:latest

cv: build-cv
	ID=$$(docker create cv:latest) && \
	  docker cp $${ID}:/cv/paul-freeman.pdf ./ && \
	  docker cp $${ID}:/cv/paul-freeman.png ./ && \
	  docker rm -v $${ID}
