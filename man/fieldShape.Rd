\name{fieldShape}
\alias{fieldShape}
\title{
  Building the plot shape file
}
\description{
  The user should select the four experimental field corners and the shape file with plots will be automatcly built using a grid with the number of ranges and rows. Attention: The base of image should be parallel to axis X, please use first the function fieldRotate().
}
\usage{
  fieldShape(mosaic,ncols=10,nrows=10,nPoint=4,fieldMap=NULL,fieldData=NULL,ID=NULL,theta=NULL,plot=T,fast.plot=F)
}
\arguments{
  \item{mosaic}{
    object of class stack obtained from function fieldRotate() with the base of image parallel to axis X.
  }
  \item{ncols}{
    number of ranges.
  }
  \item{nrows}{
    number of rows.
  }
  \item{nPoint}{
    number of points necessary to select field boundaries or area to remove (4 >= nPoint <= 50).
  }
    \item{fieldMap}{
    matrix with plots ID identified by rows and ranges, please use first the funsction fieldMap().
  }
  \item{fieldData}{
    data frame with plot ID and all attributes of each plot (Traits as columns and genotypes as rows).
  }
  \item{ID}{
    name of plot ID in the fieldData file to combine with fieldShape.
  }
  \item{theta}{
    angle of rotation used on function fieldRotate(). It is an important step to fit the fieldShape on the original image.
  }
  \item{plot}{
    if is TRUE the crop image and fieldShape will be plotted.
  }
  \item{fast.plot}{
    if TRUE only the grey scale image will be plotted as reference (faster approach).
  }
}
\details{
  The function returns the fieldShape format SpatialPolygonsDataFrame with plots numbered from left to right and top to bottom, and a new reduced image with format stack. The fieldMap can be used to identify the plot ID.
}
\value{
  List with fieldShape format SpatialPolygonsDataFrame and experimental field image with format stack.
}
\references{
 Matias FI, Caraza-Harter MV, Endelman JB. FIELDimageR: An R package to analyze orthomosaic images from agricultural field trials. The Plant Phenome J. 2020;e20005. https://doi.org/10.1002/ppj2.20005
}
\examples{
  ##see Vignette at https://github.com/filipematias23/FIELDimageR
}
