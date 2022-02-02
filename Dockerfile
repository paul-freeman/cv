# syntax=docker/dockerfile:1
FROM texlive/texlive:TL2019-historic AS builder

# setup
RUN apt-get install -y imagemagick

WORKDIR /cv
COPY ./paul-freeman.tex /cv/paul-freeman.tex

# copy in the CV template
COPY ./twentysecondcv.cls /cv/twentysecondcv.cls

# copy in the fonts needed by the CV template
COPY ./fonts /cv/fonts

# build the CV
RUN lualatex paul-freeman.tex

# replace the ImageMagick policy with one that allows us to convert to PNG
COPY ./ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml

# convert the CV to PNG
RUN convert -density 300 paul-freeman.pdf -quality 90 paul-freeman.png

# put in outputs in a clean (and small) image
FROM alpine
COPY --from=builder /cv/paul-freeman.pdf /cv/paul-freeman.pdf
COPY --from=builder /cv/paul-freeman.png /cv/paul-freeman.png
