\name{fieldPlot}
\alias{fieldPlot}
\title{
  Plot of fieldShape file filled with trait value for each plot
}
\description{
  Graphic visualization of trait values for each plot using the fieldShape file and original image.
}
\usage{
  fieldPlot(fieldShape,fieldAttribute, mosaic=NULL, color=c("white","black"), alpha = 0.5, legend.position="right", na.color="gray", classes=5, round=3)
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
}
\details{
  The function returns a image with the fieldShape file filled with trait value for each plot.
}
\value{
  Graphic visualization of extracted values.
}
\references{
  Matias et al. (2019) FIELDimageR: A R Package to Analyze Orthomosaic Images from Agricultural Field Trials. (submitted)
}
\examples{
  ##see Vignette at https://github.com/filipematias23/FIELDimageR
}
