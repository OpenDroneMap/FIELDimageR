#' fieldRotate 
#' 
#' @title Rotating the image to biuld the \code{\link{fieldShape}} file
#' 
#' @description The image should be rotated to use the function \code{\link{fieldShape}}. 
#'  The base of experimental field should be parallel to axis X.
#' 
#' @param mosaic object of class stack.
#' @param theta angle of rotation, if negativo the rotation will be for the right. 
#'  If not provided the user should select two points from left to right to determine the angle of rotation.
#' @param clockwise if it is TRUE, clockwise rotation.
#' @param h if it is TRUE, the drawn line will be at horizontal, if FALSE (90-theta).
#' @param n.core number of cores to use for multicore processing (Parallel).
#' @param extentGIS if TRUE the rotated image will have an adjusted extent 
#'  based on the original image (It is an important step to fit the fieldShape on the original image).
#' @param DSMmosaic DSM should be used if the file of height is provided.
#' @param plot if it is TRUE the original and rotated image will be plotted.
#' @param type character indicating the type of plotting, please check help("lines").
#' @param lty line types, please check help("lines").
#' @param lwd line width, please check help("lines").
#' @param fast.plot if TRUE only the grey scale image will be plotted as reference (faster approach).
#' 
#' 
#' @importFrom raster raster projection plotRGB res projectRaster crs extent atan2 as.list as.data.frame as.matrix
#' @importFrom raster crop rasterToPolygons mask extract clump drawLine drawPoly xyFromCell
#' @importFrom graphics abline axis lines par plot points locator legend
#' @importFrom grDevices grey rgb col2rgb
#' @importFrom sp bbox Polygons Polygon SpatialPolygonsDataFrame SpatialPolygons spsample SpatialPointsDataFrame over proj4string
#' @importFrom maptools elide 
#' 
#'
#' @return A list with two element
#' \itemize{
#'   \item \code{mosaic} rotated image format stack with the base of experimental field parallel to axis X.
#' }
#' 
#'
#' @export
fieldRotate <- function(mosaic, theta = NULL, clockwise = TRUE, h = FALSE, n.core = NULL, extentGIS = FALSE, 
                        DSMmosaic = NULL, plot = TRUE, type = "l", lty = 2, lwd = 3, fast.plot = FALSE) {
  mosaic <- raster::stack(mosaic)
  num.band<-length(mosaic@layers)
  print(paste(num.band," layers available", sep = ""))
  par(mfrow=c(1,2))
  if(!is.null(DSMmosaic)){
    par(mfrow=c(1,3))
    if(raster::projection(DSMmosaic)!=raster::projection(mosaic)){stop("DSMmosaic and RGBmosaic must have the same projection CRS")}}
  if(plot|is.null(theta)){
    if(fast.plot){
      raster::plot(mosaic[[1]], col=grey(1:100/100), axes=FALSE, box=FALSE, legend=FALSE)}
    if(!fast.plot){
      if(num.band>2){plotRGB(RGB.rescale(mosaic,num.band=3), r = 1, g = 2, b = 3)}
      if(num.band<3){raster::plot(mosaic, axes=FALSE, box=FALSE)}}}
  rotate <- function(x, angle=0, resolution=res(x)) {
    y <- x
    raster::crs(y) <- "+proj=aeqd +ellps=sphere +lat_0=90 +lon_0=0"
    projectRaster(y, res=resolution, crs=paste0("+proj=aeqd +ellps=sphere +lat_0=90 +lon_0=", -angle))}
  if(is.null(theta)){
    print("Select 2 points from left to right on image in the plots space. Use any horizontal line in the field trial of interest as a reference.")
    c1.a <- locator(type="p",n = 1, col="red",pch=19)
    c1.b <- locator(type="p",n = 1, col="red",pch=19)
    c1<-as.data.frame(mapply(c, c1.a, c1.b))
    colnames(c1)<-c("x","y")
    lines(c1, col= "red", type=type, lty=lty, lwd=lwd)
    if((c1$y[1]>=c1$y[2])&(c1$x[2]>=c1$x[1])){theta = (atan2((c1$y[1] - c1$y[2]), (c1$x[2] - c1$x[1])))*(180/pi)}
    if((c1$y[2]>=c1$y[1])&(c1$x[2]>=c1$x[1])){theta = (atan2((c1$y[2] - c1$y[1]), (c1$x[2] - c1$x[1])))*(180/pi)}
    if((c1$y[1]>=c1$y[2])&(c1$x[1]>=c1$x[2])){theta = (atan2((c1$y[1] - c1$y[2]), (c1$x[1] - c1$x[2])))*(180/pi)}
    if((c1$y[2]>=c1$y[1])&(c1$x[1]>=c1$x[2])){theta = (atan2((c1$y[2] - c1$y[1]), (c1$x[1] - c1$x[2])))*(180/pi)}
    if(!h){theta=90-theta}
    if(clockwise){theta=-theta}
    theta=round(theta,3)
    print(paste("Theta rotation: ",theta,sep = ""))
  }
  if (is.null(n.core)) {
    r<-rotate(mosaic,angle = theta)
  }
  if (!is.null(n.core)) {
    if (n.core > detectCores()) {
      stop(paste(" 'n.core' must be less than ", detectCores(),sep = ""))
    }
    cl <- parallel::makeCluster(n.core, output = "", setup_strategy = "sequential")
    registerDoParallel(cl)
    r <- foreach(i=1:length(mosaic@layers), .packages = c("raster")) %dopar% {rotate(mosaic[[i]], angle = theta)}
  }
  r <- raster::stack(r)
  if(extentGIS){
    m11<-apply(matrix(as.numeric(as.matrix(raster::extent(mosaic))),2),1,function(x){mean(x)})
    m22<-apply(matrix(as.numeric(as.matrix(raster::extent(r))),2),1,function(x){abs(diff(c(x[2],x[1]))/2)})
    raster::extent(r)<-c(as.numeric(c(m11[1]-m22[1])), as.numeric(c(m11[1]+m22[1])), as.numeric(c(m11[2]-m22[2])), as.numeric(c(m11[2]+m22[2])))
    raster::crs(r)<-raster::crs(mosaic)
  }
  Out<-r
  if(plot){
    if(fast.plot){
      raster::plot(r[[1]], col=grey(1:100/100), axes=FALSE, box=FALSE, legend=FALSE)}
    if(!fast.plot){
      if(num.band > 2){
        X_GB <- RGB.rescale(r,num.band=3)
        raster::plotRGB(X_GB, r = 1, g = 2, b = 3)
        }
      if(num.band<3){raster::plot(r, axes=FALSE, box=FALSE)}}}
  if(!is.null(DSMmosaic)){
    DSMmosaic <- raster::stack(DSMmosaic)
    DSMmosaic <- rotate(DSMmosaic,angle = theta)
    raster::plot(DSMmosaic, axes=FALSE, box=FALSE)
    if(extentGIS){
      raster::extent(DSMmosaic)<-c(as.numeric(c(m11[1]-m22[1])), as.numeric(c(m11[1]+m22[1])), as.numeric(c(m11[2]-m22[2])), as.numeric(c(m11[2]+m22[2])))
      raster::crs(DSMmosaic)<-raster::crs(mosaic)
    }
    Out<-list(rotatedMosaic=r,rotatedDSM=DSMmosaic)
  }
  par(mfrow=c(1,1))
  return(Out)
}
