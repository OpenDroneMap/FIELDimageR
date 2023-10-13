#' RGB.rescale
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#' 
#' @importFrom raster values
#'
#' @noRd
RGB.rescale <- function(mosaic, num.band) {
  for (i in 1:num.band) {
    values_i <- values(mosaic[[i]])
    values_i <- pmin(pmax(values_i, 0), 255)
    values(mosaic[[i]]) <- values_i
  }
  return(mosaic)
}
