#' fieldMask 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#' 
#' @importFrom utils read.csv

#' 
#' @title Removing background (e.g., soil) using vegetation index.
#' 
#' @description Different vegetation indices can be used to remove images background. For the list of indices please visit the FIELDimageR manual at link: https://github.com/OpenDroneMap/FIELDimageR#P6
#' 
#' @param mosaic object of class stack with at least 3 bands.
#' @param Red,Green,Blue,RedEdge,NIR respective position of the band at the original image file.
#' @param index vector with the vegetation indices to be calculated. For the list of indices please visit the FIELDimageR manual at link:
#' @param myIndex user can calculate a diferent index using the bands names, e.g. "(Green+Blue)/Red-NIR/RedEdge"
#' @param mask if avaliable the soil will be removed following this mask and not the vegetation index, cropValue and cropAbove must be used.
#' @param cropValue referent value of soil in the image.
#' @param cropAbove if TRUE all values above the cropValue will be accounted to make the mask.
#' @param projection if TRUE the projection will not be accounted to the mask.
#' @param DSMmosaic,DSMcropAbove,DSMcropValue DSM should be used if the file of height is provided.
#' @param plot if is TRUE the original and crop image will be plotted.
#' 
#' @importFrom utils read.csv
#' @importFrom terra nlyr
#' 
#'@return A list with elements:
#' \itemize{
#'   \item The function returns a image format stack with the original bands (layers) without the background and mask with logical values of 0 and 1 for vegetation or soil.
#' }
#' 
#'
#' @export
fieldMask<- function(mosaic, Red = 1, Green = 2, Blue = 3, RedEdge = NULL, NIR = NULL, mask = NULL, index = "HUE",
                     myIndex = NULL, cropValue = 0, cropAbove = TRUE, projection = TRUE, DSMmosaic = NULL, 
                     DSMcropAbove = TRUE, DSMcropValue = 0, plot = TRUE) {
  Ind <- read.csv(file=system.file("extdata", "Indices.txt", package = "FIELDimageR", mustWork = TRUE),
                  header = TRUE, sep = "\t")
  num.band <- nlyr(mosaic)
  print(paste(num.band," layers available", sep = ""))
  if(is.null(mask)){
    if(num.band<3){stop("At least 3 bands (RGB) are necessary to calculate indices available in FIELDimageR")}
    if(!is.null(RedEdge)|!is.null(RedEdge)){
      if(num.band<4){
        stop("RedEdge and/or NIR is/are not available in your mosaic")
      }}
    IRGB = as.character(Ind$index)
    if(is.null(index)|length(index)>1){stop("Only one index must be chosen for this step")}
    if(!all(index%in%IRGB)){stop(paste("Index: ",as.character(index[!index%in%IRGB])," is not available in FIELDimageR",sep = ""))}
    NIR.RE<-as.character(Ind$index[Ind$band%in%c("RedEdge","NIR")])
    if(any(NIR.RE%in%index)&is.null(NIR)){stop(paste("Index: ",as.character(NIR.RE[NIR.RE%in%index])," need NIR/RedEdge band to be calculated",sep = ""))}
    B <- mosaic[[Blue]]
    G <- mosaic[[Green]]
    R <- mosaic[[Red]]
    names(mosaic)[c(Blue, Green, Red)] <- c("Blue", "Green", "Red")
    if (!is.null(RedEdge)) {
      RE <- mosaic[[RedEdge]]
      names(mosaic)[RedEdge] <- "RedEdge"
    }
    
    if (!is.null(NIR)) {
      NIR1 <- mosaic[[NIR]]
      names(mosaic)[NIR] <- "NIR"
    }
    mr<-eval(parse(text = as.character(Ind$eq[as.character(Ind$index)==index])))
    if(!is.null(myIndex)){
      print(paste("Mask equation myIndex=",myIndex, sep = ""))
      Blue<-B
      Green<-G
      Red<-R
      if(!is.null(NIR)){NIR<-NIR1}
      if(!is.null(RedEdge)){RedEdge<-RE}
      mr<-eval(parse(text = as.character(myIndex)))
    }
  }
  if(!is.null(mask)){
    if(nlyr(mask)>1){stop("Mask must have only one band.")}
    mr<-mask
    mosaic<-terra::crop(x = mosaic, y = mr)
    if(projection){
      mosaic <- project(mosaic, mask, method = "near")
    }
  }
  
  if(cropAbove){
    m<-mr>cropValue
  }
  if(!cropAbove){
    m<-mr<cropValue
  }
  
  par(mfrow=c(1,3))
  if(!is.null(DSMmosaic)){
    par(mfrow=c(1,4))
    if(projection(DSMmosaic)!=projection(mosaic)){stop("DSMmosaic and RGBmosaic must have the same projection CRS, use fieldRotate() in both files.")}}
  
  if(plot){if(num.band>2){plotRGB(RGB.rescale(mosaic,num.band=3), r = 1, g = 2, b = 3)}
    if(num.band<3){terra::plot(mosaic, axes=FALSE, box=FALSE)}
    terra::plot(m, col=grey(1:100/100), axes=FALSE, box=FALSE)}
  
  mosaic <- terra::mask(mosaic, m, maskvalue=TRUE)
  
  if(plot){if(num.band>2){plotRGB(RGB.rescale(mosaic,num.band=3), r = 1, g = 2, b = 3)}
    if(num.band<3){terra::plot(mosaic, axes=FALSE, box=FALSE)}}
  
  Out<-list(newMosaic=mosaic,mask=m)
  if(!is.null(DSMmosaic)){
    DSMmosaic <-terra::crop(x = DSMmosaic, y = m)
    if(DSMcropAbove){
      mDEM<-m>DSMcropValue
    }
    if(!DSMcropAbove){
      mDEM<-m<DSMcropValue
    }
    if(projection){
      DSMmosaic <- project(DSMmosaic,mDEM,method = 'near')
    }
    DSMmosaic <- terra::mask(DSMmosaic, mDEM, maskvalue=TRUE)
    if(plot){terra::plot(DSMmosaic, axes=FALSE, box=FALSE)}
    Out<-list(newMosaic=mosaic,mask=m,DSM=DSMmosaic)
  }
  par(mfrow=c(1,1))
  return(Out)
}
