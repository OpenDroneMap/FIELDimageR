fieldRotate<-function(mosaic, theta=NULL, clockwise=T, h=F, DSMmosaic=NULL, plot=T, type="l", lty=2, lwd=3){
  source(file=system.file("extdata","RGB.rescale.R", package = "FIELDimageR", mustWork = TRUE))
  mosaic <- stack(mosaic)
  num.band<-length(mosaic@layers)
  print(paste(num.band," layers available", sep = ""))
  par(mfrow=c(1,2))
  if(!is.null(DSMmosaic)){
    par(mfrow=c(1,3))
    if(projection(DSMmosaic)!=projection(mosaic)){stop("DSMmosaic and RGBmosaic must have the same projection CRS")}}
  if(plot|is.null(theta)){
  if(num.band>2){plotRGB(RGB.rescale(mosaic,num.band=3), r = 1, g = 2, b = 3)}
  if(num.band<3){raster::plot(mosaic, axes=FALSE, box=FALSE)}}
  rotate <- function(x, angle=0, resolution=res(x)) {
    y <- x
    crs(y) <- "+proj=aeqd +ellps=sphere +lat_0=90 +lon_0=0"
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
  r<-rotate(mosaic,angle = theta)
  r <- stack(r)
  Out<-r
  if(plot){
    if(num.band>2){plotRGB(RGB.rescale(r,num.band=3), r = 1, g = 2, b = 3)}
    if(num.band<3){raster::plot(r, axes=FALSE, box=FALSE)}}
  if(!is.null(DSMmosaic)){
    DSMmosaic <- stack(DSMmosaic)
    DSMmosaic<-rotate(DSMmosaic,angle = theta)
    raster::plot(DSMmosaic, axes=FALSE, box=FALSE)
    Out<-list(rotatedMosaic=r,rotatedDSM=DSMmosaic)
  }
  par(mfrow=c(1,1))
  return(Out)
}
