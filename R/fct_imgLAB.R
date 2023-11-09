#' imgLAB 
#' 
#' @title Set min and max values and crs to terra object
#' 
#' @description Set minmax values and crs to terra object
#' 
#' @param img image/object class \code{terra}
#' 
#' @importFrom terra crs nlyr setMinMax hasMinMax plotRGB
#' 
#' @return \code{terra} object
#'
#' @export
imgLAB <- function(img){
  if(class(img)%in%c("SpatRaster")){
    if(hasMinMax(img[[1]])==FALSE){
      img <- setMinMax(img)
    }
    if (crs(img)=='') {
      if(nlyr(img) == 3){
        crs(img)<- 'epsg:3057'
        names(img)<-c('Red','Green','Blue')
      }
      else if(nlyr(img)==1){
        crs(img)<- 'epsg:3057'
        names(img)<-c('band')
      }
    }
    return(img)
    return(plotRGB(img))
  }else {
    stop("Input is not a SpatRaster object.")
  }
}