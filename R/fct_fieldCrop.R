#' fieldCrop 
#' 
#' @title Selecting experimental field from original image
#' 
#' @description It calculates the percentage of object area in the entire mosaic or per plot using the fieldShape file.
#' 
#' @param mosaic object mask of class stack from the function \code{\link{fieldMask}}.
#' @param fieldShape crop the image using the fieldShape as reference. If fieldShape=NULL, four points should be selected 
#'  directly on the original image to determine the experimental field.
#' @param nPoint number of points necessary to select field boundaries or area to remove (4 >= nPoint <= 50).
#' @param remove if TRUE the selected area will be removed from the image.
#' @param plot if \code{TRUE} (by default) plots the original and cropped image.
#' @param type character indicating the type of plotting, please check help("lines").
#' @param lty line types, please check help("lines").
#' @param lwd line width, please check help("lines").
#' @param fast.plot  if TRUE only the grey scale image will be plotted as reference (faster approach).
#'  if TRUE only the grey scale image will be plotted as reference (faster approach).
#' 
#' @importFrom raster plotRGB mask
#' @importFrom graphics locator lines 
#' @importFrom sp Polygons Polygon SpatialPolygonsDataFrame SpatialPolygons
#'
#' 
#' @return A image format stack.
#' 
#' @export
fieldCrop <- function(mosaic, fieldShape = NULL, nPoint = 4, plot = TRUE, remove = FALSE, type = "l", 
                      lty = 2, lwd = 3, fast.plot = FALSE) {
  mosaic <- stack(mosaic)
  num.band <- length(mosaic@layers)
  print(paste(num.band," layers available", sep = ""))
  if(nPoint<4|nPoint>50){stop("nPoint must be >= 4 and <= 50")}
  withr::local_par(mfrow = c(1, 2))
  if(is.null(fieldShape)|plot){
    if(fast.plot){
      raster::plot(mosaic[[1]], col=grey(1:100/100), axes=FALSE, box=FALSE, legend=FALSE)}
    if(!fast.plot){
      if(num.band>2){plotRGB(RGB.rescale(mosaic,num.band=3), r = 1, g = 2, b = 3)}
      if(num.band<3){raster::plot(mosaic, axes=FALSE, box=FALSE)}}
  }
  if(!is.null(fieldShape)){
    if(raster::projection(fieldShape) != raster::projection(mosaic)){
      stop("fieldShape and mosaic must have the same raster::projection CRS. Use fieldRotate() for both files.")
      }
    r <- crop(x = mosaic, y = fieldShape)
  }
  c1 <- NULL
  if(is.null(fieldShape)) {
    print(paste("Select ",nPoint," points at the corners of field of interest in the plots space.",sep = ""))
    for(i in 1:nPoint){
      c1.1<-locator(type="p",n = 1, col="red",pch=19)
      c1<-rbind(c1,c(c1.1$x,c1.1$y))
    }
    c1<-rbind(c1,c1[1,])
    colnames(c1)<-c("x","y")
    lines(c1, col= "red", type=type, lty=lty, lwd=lwd)
  }
  if(!is.null(c1)) {
    p1 <- Polygons(list(Polygon(c1)), "x")
    f1 <- SpatialPolygonsDataFrame( SpatialPolygons(list(p1)), data.frame( z=1, row.names=c("x") ) )
    raster::projection(f1) <- raster::projection(mosaic)
    if(!remove){r <- crop(x = mosaic, y = f1)}
    if(remove){r <- mask(x = mosaic, mask = f1, inverse = remove)}
  }
  r <- stack(r)
  if(plot){
    if(fast.plot) {
      raster::plot(r[[1]], col=grey(1:100/100), axes=FALSE, box=FALSE, legend=FALSE)}
    if(!fast.plot){
      if(num.band>2){plotRGB(RGB.rescale(r,num.band=3), r = 1, g = 2, b = 3)}
      if(num.band<3){raster::plot(r, axes=FALSE, box=FALSE)}}}
  return(r)
}
