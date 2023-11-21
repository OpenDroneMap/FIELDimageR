#' imgEBI 
#' 
#' @title Converts a terra object to an EBImage object
#' 
#' @description Converts a terra object to an EBImage object
#' 
#' @param img image/object class \code{terra}
#' 
#' @importFrom EBImage Image
#' 
#' @return \code{EBImage} object
#'
#' @export
imgEBI <- function(img) {
  if (class(img) %in% c("SpatRaster")) {
    nBand <- nlyr(img)
    
    if (nBand == 1) {
      if (length(dim(img)) >= 2) {
        if (terra::is.bool(img) || is.factor(img)||isClass(img)) {  # Check if img is boolean or factor
          img[is.na(img)] <- 0
          x <- terra::as.array(img)
          x <- t(x[, , 1] * 255)  # Multiply by 255
          x <- EBImage::Image(x)
        }
        else if (!(minmax(img)[1] == 1)) {
          x <- terra::as.array(img)
          x <- t(x[, , 1] / 255)
          x <- EBImage::Image(x)
        } else if (minmax(img)[1] == 1) {
          x <- terra::as.array(img)
          x <- t(x[, , 1])
          x <- EBImage::Image(x)
        }
        return(x)
      } else {
        stop("Input 'img' must have at least two dimensions.")
      }
    } else if (nBand == 3) {
      # Handle the 3-band case
      if (length(dim(img)) >= 3) {
        band1 <- terra::as.array(t(img[[1]] / 255))
        band2 <- terra::as.array(t(img[[2]] / 255))
        band3 <- terra::as.array(t(img[[3]] / 255))
        rgb <- array(c(band1, band2, band3), dim = c(dim(band1)[1], dim(band1)[2], nlyr(img)))
        rgb <- EBImage::Image(rgb)
        colorMode(rgb) = Color
        return(rgb)
      } else {
        stop("Input 'img' must have at least three dimensions for a 3-band image.")
      }
    } else {
      stop("Unsupported number of bands: ", nBand)
    }
  } else {
    stop("Input 'img' must be a SpatRaster.")
  }
}
