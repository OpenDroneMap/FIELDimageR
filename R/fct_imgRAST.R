#' imgRAST 
#' 
#' @title Converts an EBImage object to a terra object
#' 
#' @description Converts an EBImage object to a terra object
#' 
#' @param img image/object class \code{EBImage}
#' 
#' @importFrom terra rast
#' 
#' @return \code{terra} object
#'
#' @export
imgRAST<-function(img){
  if (!requireNamespace("EBImage", quietly = TRUE)) {
    stop("EBImage package is required for this function.")
  }
  if(class(img)=='Image') {
    if(!is.na(dim(img)[3])){
      b1<-t(imageData(img)[,,1]*255)
      b2<-t(imageData(img)[,,2]*255)
      b3<-t(imageData(img)[,,3]*255)
      rgb<-array(c(b1,b2,b3),dim = c(dim(b1)[1],dim(b1)[2],dim(img)[3]))
    } else if (is.na(dim(img)[3])){
      b<-t(imageData(img)*255)
      rgb<-as.array(b)
    } else {
      stop("Invalid number of channels in the image.")
    }
    rast_obj <- rast(rgb)
    crs(rast_obj)<-'epsg:3057'
    return(rast_obj)
  } else {
    stop("Input is not an EBImage object.")
  }
}