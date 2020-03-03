\name{fieldArea}
\alias{fieldArea}
\title{
  Percentage of object area
}
\description{
  Calculating the percentage of object area in the entire mosaic or per plot using the fieldShape file
}
\usage{
  fieldArea(mosaic, areaValue=0, fieldShape=NULL, n.core=NULL, plot=T)
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
}
\details{
  The function returns a data frame with the percentage of object area per plot, and the new fieldShape (format SpatialPolygonsDataFrame) with percentage of object area per plot.
}
\value{
  Percentage of object area per plot represented in DataFrame, and the new fieldShape format SpatialPolygonsDataFrame.
}
\references{
  Matias et al. (2019) FIELDimageR: A R Package to Analyze Orthomosaic Images from Agricultural Field Trials. (submitted)
}
\examples{
  ##see Vignette at https://github.com/filipematias23/FIELDimageR
}
