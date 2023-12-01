all: cv

.PHONY: clean build-cv cv

clean:
	rm cv.pdf cv.png

build-cv:
	DOCKER_BUILDKIT=1 docker build . -t cv:latest

cv: build-cv
	ID=$$(docker create cv:latest) && \
	  docker cp $${ID}:/cv/cv.pdf ./ && \
	  docker cp $${ID}:/cv/cv.png ./ && \
	  docker rm -v $${ID}
