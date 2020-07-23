FROM cyversevice/rstudio-verse:3.6.3
LABEL maintainer="Chris Schnaufer <schnaufer@email.arizona.edu>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libxml2-dev \
    zlib1g-dev \
    libfftw3-dev \
    gdal-bin \
    libgdal-dev \
    libxt-dev

RUN install2.r --error \
    sp \
    raster \
    rgdal \
    scales \
    xml2 \
    git2r \
    usethis \
    fftwtools \
    devtools

RUN installGithub.r filipematias23/FIELDimageR
