\name{fieldCrop}
\alias{fieldCrop}
\title{
  Selecting experimental field from original image
}
\description{
   Reduction of the original image size using the experimental field as reference
}
\usage{
  fieldCrop(mosaic, fieldShape=NULL, nPoint=4, plot=T, remove=F, type="l", lty=2, lwd=3, fast.plot=F)
}
\arguments{
  \item{mosaic}{
    object of class stack.
  }
  \item{fieldShape}{
    crop the image using the fieldShape as reference. If fieldShape=NULL, four points should be selected directly on the original image to determine the experimental field.
  }
  \item{nPoint}{
    number of points necessary to select field boundaries or area to remove (4 >= nPoint <= 50).
  }
  \item{remove}{
    if TRUE the selected area will be removed from the image.
  }
  \item{plot}{
    if TRUE (by default) plots the original and cropped image.
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
  The function returns a new reduced image from experimental field with stack format.
}
\value{
  Image format stack.
}
\references{
  Matias et al. (2019) FIELDimageR: A R Package to Analyze Orthomosaic Images from Agricultural Field Trials. (submitted)
}
\examples{
##see Vignette at https://github.com/filipematias23/FIELDimageR
}
