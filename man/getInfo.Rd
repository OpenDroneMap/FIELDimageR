\name{getInfo}
\alias{getInfo}
\title{
  Extract information from image using the fieldShape file as reference
}
\description{
  Function that use raster::extract() to extract information from the original image using fieldShape file as reference.
}
\usage{
  getInfo(mosaic,fieldShape,fun = "mean",plot=F,buffer=NULL,n.core=NULL,...)
}
\arguments{
\item{mosaic}{
    object of class stack.
  }
  \item{fieldShape}{
    plot shape file, please use first the function fieldShape().
  }
  \item{fun}{
    function to summarize the values (e.g. mean).
  }
  \item{plot}{
    if is TRUE the original and crop image will be plotted.
  }
  \item{buffer}{
    negative values should be used to remove boundaries from neighbor plot (normally the unit is meters, please use values as 0.1 = 10 cm).
  }
  \item{n.core}{
    number of cores to use for multicore processing (Parallel).
  }
  \item{...}{
    please see raster::extract() for more options.
  }
}
\details{
  The function returns a data frame with values by plots, and a new reduced image with format stack.
}
\value{
  List with a data frame with values by plot and experimental field image with format stack.
}
\references{
  Matias et al. (2019) FIELDimageR: A R Package to Analyze Orthomosaic Images from Agricultural Field Trials. (submitted)
}
\examples{
  ##see Vignette at https://github.com/filipematias23/FIELDimageR
}
