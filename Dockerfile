# syntax=docker/dockerfile:1
FROM texlive/texlive:TL2019-historic AS builder

# setup
RUN apt-get update
RUN apt-get install -y imagemagick

WORKDIR /cv
COPY ./cv.tex /cv/cv.tex

# copy in the CV template
COPY ./twentysecondcv.cls /cv/twentysecondcv.cls

# copy in the fonts needed by the CV template
COPY ./fonts /cv/fonts

# build the CV
RUN lualatex cv.tex

# replace the ImageMagick policy with one that allows us to convert to PNG
COPY ./ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml

# convert the CV to PNG
RUN convert -density 300 cv.pdf -quality 90 -background white -alpha remove -flatten cv.png

# put in outputs in a clean (and small) image
FROM alpine
COPY --from=builder /cv/cv.pdf /cv/cv.pdf
COPY --from=builder /cv/cv.png /cv/cv.png
