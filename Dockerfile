FROM rocker/rstudio:latest
LABEL maintainer="Chris Schnaufer <schnaufer@email.arizona.edu>"

RUN apt install -y libxml2-dev zlib1g-dev libfftw3-dev gdal-bin libgdal-dev libxt-dev
RUN echo "install.packages(\"sp\", repos=\"https://cran.rstudio.com\")" | R --no-save
RUN echo "install.packages(\"raster\", repos=\"https://cran.rstudio.com\")" | R --no-save
RUN echo "install.packages(\"rgdal\", repos=\"https://cran.rstudio.com\")" | R --no-save
RUN echo "install.packages(\"scales\", repos=\"https://cran.rstudio.com\")" | R --no-save
RUN echo "install.packages(\"xml2\", repos=\"https://cran.rstudio.com\")" | R --no-save
RUN echo "install.packages(\"git2r\", repos=\"https://cran.rstudio.com\")" | R --no-save
RUN echo "install.packages(\"usethis\", repos=\"https://cran.rstudio.com\")" | R --no-save
RUN echo "install.packages(\"fftwtools\", repos=\"https://cran.rstudio.com\")" | R --no-save
RUN echo "install.packages(\"devtools\", repos=\"https://cran.rstudio.com\")" | R --no-save
RUN echo "devtools::install_github(\"filipematias23/FIELDimageR\")" | R --no-save
