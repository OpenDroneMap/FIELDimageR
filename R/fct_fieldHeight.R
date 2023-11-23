#' fieldHeight
#' 
#' @title Mosaic height and volume based on the digital surface model (DSM) 
#' 
#' @description It calculates pixel height and volume in the entire mosaic using the digital surface model (DSM).
#' 
#' @param dsm_before digital surface model (DSM) mosaic class SpatRaster to be used as base line (minumun height or soil level).
#' @param dsm_after digital surface model (DSM) mosaic class SpatRaster to be used as aimed line (maximum height or plants in the field). 
#'  
#' @importFrom terra resample cellSize
#' 
#'
#' @return  list with \code{height} and {volume} as a new \code{SpatRaster} object.
#' 
#'
#' @export
fieldHeight<-function(dsm_before,dsm_after){
  if (!inherits(dsm_before,"SpatRaster") || !nlyr(dsm_before) == 1 || terra::is.bool(dsm_before) || is.list(dsm_before)) {
    stop("Error: Invalid 'dsm_before' raster object.")
  }
  if (!inherits(dsm_after,"SpatRaster") || !nlyr(dsm_after) == 1 || terra::is.bool(dsm_after) || is.list(dsm_after)) {
    stop("Error: Invalid 'dsm_after' raster object.")
  }
  dsm.c <- resample(dsm_before, dsm_after)
  height <- dsm_after-dsm.c
  names(height)<-"height"
  volume<-terra::cellSize(height)*height
  names(volume)<-"volume"
  mosaic<-append(height,volume)
  return(mosaic)
}
