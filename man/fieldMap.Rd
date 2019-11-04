\name{fieldMap}
\alias{fieldMap}
\title{
  Organazing the field map in function of plot order
}
\description{
  Field map ID identification to align with plots shapefile built with fieldShape(). The plots are numbered from left to right and top to bottom.
}
\usage{
  fieldMap(fieldPlot, fieldRange, fieldRow, decreasing=F)
}
\arguments{
  \item{fieldPlot}{
    vector with plot ID
  }
  \item{fieldRange}{
    vector with range ID
  }
  \item{fieldRow}{
    vector with row ID
  }
  \item{decreasing}{
    if FALSE the plots will be order left to right and right to left every other line following the breeding field design.
  }
}
\details{
  The function returns a matrix with plots ID identified by rows and ranges
}
\value{
  Matrix with plots ID.
}
\references{
  Matias et al. (2019) FIELDimageR: A R Package to Analyze Orthomosaic Images from Agricultural Field Trials. (submitted)
}
\examples{
  ##see Vignette at https://github.com/filipematias23/FIELDimageR
}
