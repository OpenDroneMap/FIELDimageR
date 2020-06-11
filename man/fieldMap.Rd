\name{fieldMap}
\alias{fieldMap}
\title{
  Organazing the field map in function of plot order
}
\description{
  Field map ID identification to align with plots shapefile built with fieldShape(). The plots are numbered from left to right and top to bottom.
}
\usage{
  fieldMap(fieldPlot, fieldColumn, fieldRow, decreasing=F)
}
\arguments{
  \item{fieldPlot}{
    vector with plot ID
  }
  \item{fieldColumn}{
    vector with column ID
  }
  \item{fieldRow}{
    vector with row ID
  }
  \item{decreasing}{
    if FALSE the plots will be order left to right and right to left every other line following the breeding field design.
  }
}
\details{
  The function returns a matrix with plots ID identified by rows and column
}
\value{
  Matrix with plots ID.
}
\references{
  Matias FI, Caraza-Harter MV, Endelman JB. FIELDimageR: An R package to analyze orthomosaic images from agricultural field trials. The Plant Phenome J. 2020;e20005. https://doi.org/10.1002/ppj2.20005
}
\examples{
  ##see Vignette at https://github.com/filipematias23/FIELDimageR
}
