\name{polygonShape}
\alias{polygonShape}
\title{
  Building shapefile with polygons
}
\description{
  The user should select points to make polygons in the image. Shapefile with polygons will be automatically built. Attention: fieldRotate() is not necessary.
}
\usage{
  polygonShape(mosaic,nPolygon=1,nPoint=4,polygonID=NULL,polygonData=NULL,ID=NULL,cropPolygon=F,remove=F,plot=T,fast.plot=F)
}
\arguments{
  \item{mosaic}{
    object of class stack.
  }
  \item{nPolygon}{
    number of polygons.
  }
  \item{nPoint}{
    number of points necessary to select field boundaries or area to remove (4 >= nPoint <= 50).
  }
  \item{polygonID}{
    a vector with polygon names with same order of drawing. If is NULL the ID will be the sequence of drawing.
  }
  \item{polygonData}{
    data frame with polygon ID and all attributes of each polygon (Traits as columns and polygon as rows).
  }
  \item{ID}{
    the column in polygonData with polygons names (ID) which the data will be combined with fieldShape.
  }
  \item{cropPolygon}{
    if TRUE the mosaic will be crooped using polygons shape.
  }
  \item{remove}{
    if TRUE the selected area will be removed from the image.
  }
  \item{plot}{
    if is TRUE the crop image and fieldShape will be plotted.
  }
  \item{fast.plot}{
    if TRUE only the grey scale image will be plotted as reference (faster approach).
  }
}
\details{
  The function returns the fieldShape format SpatialPolygonsDataFrame with plots numbered by the sequence of drawings and a new reduced image with format stack. The polygonID parameter can be used to identify each polygon.
}
\value{
  List with fieldShape format SpatialPolygonsDataFrame and experimental field image with format stack.
}
\references{
  Matias et al. (2019) FIELDimageR: A R Package to Analyze Orthomosaic Images from Agricultural Field Trials. (submitted)
}
\examples{
  ##see Vignette at https://github.com/filipematias23/FIELDimageR
}
