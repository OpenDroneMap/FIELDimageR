\name{canopy}
\alias{canopy}
\title{
  Percentage of canopy
}
\description{
  Calculating the percentage of canopy in the entire mosaic or per plot using the fieldShape file
}
\usage{
  canopy(mosaic, canopyValue=0, fieldShape=NULL, plot=T)
}
\arguments{
  \item{mosaic}{
    object mask of class stack from the function fieldMask().
  }
  \item{canopyValue}{
    referent value of canopy in the image.
  }
  \item{fieldShape}{
    evaluate the canopy percentage per plot using the fieldShape as reference. If fieldShape=NULL, the canopy percentage will be calculated directly for the entire original image.
  }
\item{plot}{
    if is TRUE the crop image and fieldShape will be plotted.
  }
}
\details{
  The function returns a data frame with the percentage of canopy per plot, and the new fieldShape (format SpatialPolygonsDataFrame) with percentage of canopy per plot.
}
\value{
  Percentage of canopy per plot represented in DataFrame, and the new fieldShape format SpatialPolygonsDataFrame.
}
\references{
  Matias et al. (2019) FIELDimageR: A R Package to Analyze Orthomosaic Images from Agricultural Field Trials. (submitted)
}
\examples{
  ##see Vignette at https://github.com/filipematias23/FIELDimageR
}
