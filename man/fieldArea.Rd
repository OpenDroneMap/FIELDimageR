\name{fieldArea}
\alias{fieldArea}
\title{
  Percentage of object area
}
\description{
  Calculating the percentage of object area in the entire mosaic or per plot using the fieldShape file
}
\usage{
  fieldArea(mosaic, areaValue=0, fieldShape=NULL, n.core=NULL, plot=T, na.rm=FALSE)
}
\arguments{
  \item{mosaic}{
    object mask of class stack from the function fieldMask().
  }
  \item{areaValue}{
    referent value of object area in the image.
  }
  \item{fieldShape}{
    evaluate the object area percentage per plot using the fieldShape as reference. If fieldShape=NULL, the object area percentage will be calculated directly for the entire original image.
  }
  \item{n.core}{
    number of cores to use for multicore processing (Parallel).
  }
\item{plot}{
    if is TRUE the crop image and fieldShape will be plotted.
  }
  \item{na.rm}{
    logical. Should missing values (including NaN) be used?.
  }
}
\details{
  The function returns a data frame with the percentage of object area per plot, and the new fieldShape (format SpatialPolygonsDataFrame) with percentage of object area per plot.
}
\value{
  Percentage of object area per plot represented in DataFrame, and the new fieldShape format SpatialPolygonsDataFrame.
}
\references{
  Matias FI, Caraza-Harter MV, Endelman JB. FIELDimageR: An R package to analyze orthomosaic images from agricultural field trials. The Plant Phenome J. 2020;e20005. https://doi.org/10.1002/ppj2.20005
}
\examples{
  ##see Vignette at https://github.com/filipematias23/FIELDimageR
}
