\name{fieldPlot}
\alias{fieldPlot}
\title{
  Plot of fieldShape file filled with trait value for each plot
}
\description{
  Graphic visualization of trait values for each plot using the fieldShape file and original image.
}
\usage{
  fieldPlot(fieldShape,fieldAttribute, mosaic=NULL, color=c("white","black"), alpha = 0.5, legend.position="right", na.color="gray", classes=5, round=3, horiz = F)
}
\arguments{
  \item{fieldShape}{
    plot shape file, please use first the function getInfo().
  }
  \item{fieldAttribute}{
    attribute or trait which the values will fill the plots, please use first the function getInfo().
  }
  \item{color}{
    colors to interpolate, must be a valid argument.
  }
  \item{mosaic}{
    object of class stack that is not necessary, but if provided will be plotted with the fieldShape file.
  }
  \item{alpha}{
    transparency with values between 0 and 1.
  }
  \item{legend.position}{
    legend position.
  }
    \item{na.color}{
    color of missing values "NA".
  }
  \item{classes}{
    number of classes at the legend.
  }
  \item{round}{
    number of decimal digits at the legend.
  }
  \item{horiz}{
    if TRUE will plot a horizontal legend.
  }
}
\details{
  The function returns a image with the fieldShape file filled with trait value for each plot.
}
\value{
  Graphic visualization of extracted values.
}
\references{
 Matias FI, Caraza-Harter MV, Endelman JB. FIELDimageR: An R package to analyze orthomosaic images from agricultural field trials. The Plant Phenome J. 2020;e20005. https://doi.org/10.1002/ppj2.20005
}
\examples{
  ##see Vignette at https://github.com/filipematias23/FIELDimageR
}
