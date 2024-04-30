#' fieldInterpolate
#' 
#' @title Creating an interpolated raster based on  sampled poits.
#' 
#' @description Making raster based on interpolated values from sampled poits (x and y, or longitude and latitude) as predictors (independent variables).
#' 
#' @param mosaic input raster layer containing the field orthomosaic with 1 layer.
#' @param poit_shp Points shape file layer to be used as reference. 
#'  
#' @importFrom terra rast extract mask interpolate
#' @importFrom fields Tps
#'
#' @return  A new \code{SpatRaster} object.
#' 
#'
#' @export
fieldInterpolate<-function(mosaic,poit_shp){
  extra<-extract(mosaic,poit_shp, xy=TRUE)
  xy<-extra[,c(3,4)]
  v<-as.numeric(extra[,2])
  tps <- Tps(xy, v)
  Out <- rast(mosaic)
  Out <- interpolate(Out, tps)
  Out <- mask(Out, mosaic)
  return(Out)
}
  