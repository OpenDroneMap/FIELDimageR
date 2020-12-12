\name{fieldObject}
\alias{fieldObject}
\title{
  Evaluate object area, "x" distance, "y" distance, number, extent, etc.
}
\description{
  Calculating the object dimensions (e.g., area, "x" distance, "y" distance, number, extent, etc.) in the entire mosaic or per plot using the fieldShape file
}
\usage{
  fieldObject(mosaic, fieldShape=NULL, minArea=0.01, areaValue=0, watershed=F, dissolve=T, n.rem=1, na.rm=FALSE, plot=T)
}
\arguments{
  \item{mosaic}{
    object mask of class stack from the function fieldMask().
  }
  \item{fieldShape}{
    evaluate the object per plot using the fieldShape as reference. If fieldShape=NULL, the object will be evaluated directly for the entire original image.
  }
    \item{minArea}{
    used to set the minimum size percentage of plant canopy  (to remove weeds and more).
  }
  \item{areaValue}{
    referent value of object area in the image.
  }
  \item{watershed}{
    if TRUE the "watershed" algorithm will be used to differentiate objects that are touching each other.
  }
  \item{dissolve}{
    if TRUE, polygons with the same attribute value will be dissolved into multi-polygon regions. This option requires the rgeos package.
  }
   \item{n.rem}{
    number of objects that should be removed by decreasing size (n.rem=1 is the background).
  }
    \item{na.rm}{
    logical. Should missing values (including NaN) be removed?.
  }
  \item{plot}{
    if TRUE the crop image and fieldShape will be plotted.
  }
}
\details{
  The function returns a data frame with each object dimension per plot (e.g., area, x.dist, y.dist).
}
\value{
  The function returns: mosaic (cropped by plot), Dimension (area, x.dist, y.dist), numObjects (number of objects), Objects (all objects polygon shape), Polygons (all extent polygons shape), single.obj (single object polygon shape), obj.extent (each object extent), x.position (coordinates of "x" length per object) , y.position (coordinates of "y" length per object).
}
\references{
  Matias FI, Caraza-Harter MV, Endelman JB. FIELDimageR: An R package to analyze orthomosaic images from agricultural field trials. The Plant Phenome J. 2020;e20005. https://doi.org/10.1002/ppj2.20005
}
\examples{
  ##see Vignette at https://github.com/filipematias23/FIELDimageR
}
