\name{fieldDraw}
\alias{fieldDraw}
\title{
  Making draws (lines or polygons)
}
\description{
  Extracting information (x, y, value) for all cells in a line or polygon. Also, this function can be used to evaluate distances between objects or objects length.
}
\usage{
  fieldDraw<-function(mosaic,line=T,ndraw=1,dist=F,distSel=0.2,round=5,value=1,pch=16,cex=0.7,col="red",lwd=1)
}
\arguments{
  \item{mosaic}{
    object of class stack.
  }
  \item{line}{
    if TRUE the selected area will be a line otherwise it will be a polygon (line=FALSE).
  }
  \item{ndraw}{
    number of drawings (lines or polygons).
  }
  \item{dist}{
    if TRUE the distance among objects or objects length will be calculated (mosaic should be the mask from function fieldMask() and line should be line=TRUE).
  }
  \item{distSel}{
    integer indicating which proportion of estimated distances should be selected (default 0.5). If distSel=1 all estimated distances will be saved. Some distances can be artifacts caused by the mask estimation and can inflate the number of distances.
  }
  \item{round}{
    integer indicating the number of decimal places (round) or significant digits (signif) to be used.
  }
  \item{value}{
    integer indicating the value in the mask. If value=1 the objects length will be estimated if value=0 the distance between objects will be estimated.
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
  \item{lwd}{
    line width, please check help("lines").
  }
}
\details{
  The function extract information from cells in a line/polygon and estimate distances between objects or objects length.
}
\value{
  The function returns 1) drawData: matrix with each cell position "x" and "y" (line/polygon) and the cell value "layer"; 2) drawObject: the new SpatialPolygons or SpatialLines object; If dist=TRUE the function also returns 3) drawSegments: a simplified drawData matrix with segments defined in paramter "value"; and 4) drawDist: distance or length between objects.
}
\references{
  Matias FI, Caraza-Harter MV, Endelman JB. FIELDimageR: An R package to analyze orthomosaic images from agricultural field trials. The Plant Phenome J. 2020;e20005. https://doi.org/10.1002/ppj2.20005
}
\examples{
  ##see Vignette at https://github.com/filipematias23/FIELDimageR
}
