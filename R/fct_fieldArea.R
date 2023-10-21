#' fieldArea
#' 
#' @title Percentage of object area 
#' 
#' @description It calculates the percentage of object area in the entire mosaic or per plot using the fieldShape file.
#' 
#' @param mosaic object mask of class stack from the function \code{\link{fieldMask}}.
#' @param fieldShape evaluate the object area percentage per plot using the fieldShape as reference. 
#' @param field character (field name) or numeric (length nrow). Check \code{\link{terra::rasterize}}.
#'  
#' @importFrom terra rasterize vect zonal
#' 
#'
#' @return  \code{AreaPercentage} in the new \code{fieldShape} .
#' 
#'
#' @export
fieldArea <- function(mosaic, fieldShape, field = NULL) {
  if (is.null(field)) {
    terra_vect <- vect(fieldShape)
    terra_rast <- rasterize(terra_vect, mosaic, field = "ID")
    total_pixelcount <- zonal(terra_rast, terra_rast, fun = "notNA", weighted = TRUE)
    area_pixel <- zonal(mosaic[[1]], terra_rast, fun = "notNA", weighted = TRUE)
  } else {
    terra_vect <- vect(fieldShape)
    terra_rast <- rasterize(terra_vect, mosaic, field = field)
    total_pixelcount <- zonal(terra_rast, terra_rast, fun = "notNA", weighted = TRUE)
    area_pixel <- zonal(mosaic[[1]], terra_rast, fun = "notNA", weighted = TRUE)
  }
  area_percentage <- round(area_pixel[2] / total_pixelcount[2] * 100,3)
  area_percentage<-cbind(fieldShape,
                         AreaPixel=area_pixel[,2],
                         AreaPercentage=area_percentage)
  return(area_percentage)
}
