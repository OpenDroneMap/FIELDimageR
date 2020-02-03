\name{fieldRotate}
\alias{fieldRotate}
\title{
  Rotating the image to biuld the fieldShape file
}
\description{
  The image should be rotated to use the function fieldShape(). The base of experimental field should be parallel to axis X.
}
\usage{
  fieldRotate(mosaic, theta=NULL, clockwise=T, h=F, DSMmosaic=NULL, plot=T, type="l", lty=2, lwd=3, fast.plot=F)
}
\arguments{
  \item{mosaic}{
    object of class stack.
  }
  \item{theta}{
    angle of rotation, if negativo the rotation will be for the right. If not provided the user should select two points from left to right to determine the angle of rotation.
  }
  \item{clockwise}{
    if it is TRUE, clockwise rotation.
  }
  \item{h}{
    if it is TRUE, the drawn line will be at horizontal, if FALSE (90-theta).
  }
  \item{DSMmosaic}{
    DSM should be used if the file of height is provided.
  }
  \item{plot}{
    if it is TRUE the original and rotated image will be plotted.
  }
    \item{type}{
    character indicating the type of plotting, please check help("lines").
  }
  \item{lty}{
    line types, please check help("lines").
  }
  \item{lwd}{
    line width, please check help("lines").
  }
  \item{fast.plot}{
    if TRUE only the grey scale image will be plotted as reference (faster approach).
  }
}
\details{
  The function returns a image with the rotated image with format stack.
}
\value{
  Rotated image format stack with the base of experimental field parallel to axis X.
}
\references{
  Matias et al. (2019) FIELDimageR: A R Package to Analyze Orthomosaic Images from Agricultural Field Trials. (submitted)
}
\examples{
  ##see Vignette at https://github.com/filipematias23/FIELDimageR
}
