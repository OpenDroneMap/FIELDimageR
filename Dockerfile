FROM rocker/tidyverse:4.1.0
LABEL maintainer="Kenyon Ng <work@kenyon.xyz>"

# libfftw3-dev (EBImage), libgdal-dev (s2), libudunits2-dev (units), the rest (sf)

RUN apt-get update && apt-get install -y --no-install-recommends \
    libfftw3-dev \		
    libgdal-dev \
    libgeos++-dev \
    libproj-dev \
    libsqlite3-dev \ 		
    libudunits2-dev

RUN Rscript -e 'BiocManager::install("EBImage", version = "3.13")'

RUN install2.r --error \
    s2 \
    sf \
    units

RUN installGithub.r OpenDroneMap/FIELDimageR
