\name{standCount}
\alias{standCount}
\title{
  Calculating stand account for each plot
}
\description{
  The mask from function fieldMask() is used to identify the number of plants per plot.
}
\usage{
  standCount(mosaic, fieldShape, value=0, minSize=0.01, n.core = NULL, pch=16, cex=0.7, col="red")
}
\arguments{
  \item{mosaic}{
    object mask of class stack from the function fieldMask().
  }
  \item{fieldShape}{
    plot shape file, please use first the function fieldAttributes().
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
}
\details{
  The function returns a vector with the number of plants per plot, a new shapeFile and a new mosaic with Watershed layer.
}
\value{
  Number of plants per plot represented in DataFrame, new shapeFile with stand count, Watershed layer, plants canopy per plot, and plants position in the image.
}
\references{
  Matias et al. (2019) FIELDimageR: A R Package to Analyze Orthomosaic Images from Agricultural Field Trials. (submitted)
}
\examples{
  ##see Vignette at https://github.com/filipematias23/FIELDimageR
}
