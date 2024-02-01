#' fieldArea
#' 
#' @title Percentage of object area 
#' 
#' @description It calculates the percentage of object area in the entire mosaic or per plot using the fieldShape file.
#' 
#' @param mosaic object mask of class stack from the function \code{\link{fieldMask}}.
#' @param fieldShape evaluate the object area percentage per plot using the fieldShape as reference. 
#' @param field character (field name) or numeric (length nrow) at fieldShape. Default: order by PlotID. Check \code{\link{terra::rasterize}}.
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
    terra_rast <- rasterize(terra_vect, mosaic, field = "PlotID")
    total_pixelcount <- exactextractr::exact_extract(terra_rast, st_as_sf(as.polygons(terra_rast)), fun = "count",force_df = TRUE)
    area_pixel <- exactextractr::exact_extract(mosaic[[1]], st_as_sf(as.polygons(terra_rast)), fun = "count",force_df = TRUE)
  } else {
    terra_vect <- vect(fieldShape)
    terra_rast <- rasterize(terra_vect, mosaic, field = field)
    total_pixelcount <- exactextractr::exact_extract(terra_rast, st_as_sf(as.polygons(terra_rast)), fun = "count",force_df = TRUE)
    area_pixel <- exactextractr::exact_extract(mosaic[[1]], st_as_sf(as.polygons(terra_rast)), fun = "count",force_df = TRUE)
  }
  area_percentage <- round(area_pixel/ total_pixelcount * 100,3)
  names(area_percentage)<-"AreaPercentage"
  names(area_pixel)<-"PixelCount"
  area_percentage<- cbind(st_as_sf(as.polygons(terra_rast)), AreaPixel=area_pixel, area_percentage)
  return(area_percentage)
}
