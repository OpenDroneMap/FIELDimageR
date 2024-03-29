% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fct_fieldArea.R
\name{fieldArea}
\alias{fieldArea}
\title{Percentage of object area}
\usage{
fieldArea(mosaic, fieldShape, field = NULL)
}
\arguments{
\item{mosaic}{object mask of class stack from the function \code{\link{fieldMask}}.}

\item{fieldShape}{evaluate the object area percentage per plot using the fieldShape as reference.}

\item{field}{character (field name) or numeric (length nrow). Check \code{\link{terra::rasterize}}.}
}
\value{
\code{AreaPercentage} in the new \code{fieldShape} .
}
\description{
It calculates the percentage of object area in the entire mosaic or per plot using the fieldShape file.
}
\details{
fieldArea
}
