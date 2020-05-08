\name{fieldCount}
\alias{fieldCount}
\title{
  Calculating number of objects per plot
}
\description{
  The mask from function fieldMask() is used to identify the number of objects per plot.
}
\usage{
  fieldCount(mosaic, fieldShape, value=0, minSize=0.01, n.core=NULL, pch=16, cex=0.7, col="red", na.rm=FALSE)
}
\arguments{
  \item{mosaic}{
    object mask of class stack from the function fieldMask().
  }
  \item{fieldShape}{
    plot shape file.
  }
  \item{value}{
    referent value to vegetation pixels in the mask. If "HUE" was used on fieldMask() the value=0.
  }
  \item{minSize}{
    used to set the minimum size percentage of plant canopy  (to remove weeds and more).
  }
  \item{n.core}{
    number of cores to use for multicore processing (Parallel).
  }
  \item{pch}{
    point symbol, please check help("points").
  }
  \item{cex}{
    character (or symbol) expansion: a numerical vector, please check help("points").
  }
  \item{col}{
    color code or name, please check help("points").
  }
  \item{na.rm}{
    logical. Should missing values (including NaN) be removed?.
  }
}
\details{
  The function returns a vector with the number of objects per plot, a new shapeFile and a new mosaic with Watershed layer.
}
\value{
  Number of objects per plot represented in DataFrame, new shapeFile with stand count, Watershed layer, objects area per plot, and objects position in the image.
}
\references{
 Matias FI, Caraza-Harter MV, Endelman JB. FIELDimageR: An R package to analyze orthomosaic images from agricultural field trials. The Plant Phenome J. 2020;e20005. https://doi.org/10.1002/ppj2.20005
}
\examples{
  ##see Vignette at https://github.com/filipematias23/FIELDimageR
}
