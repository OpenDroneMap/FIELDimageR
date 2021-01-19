fieldRotate<-function(mosaic, theta=NULL, clockwise=T, h=F, n.core=NULL, extent=F, DSMmosaic=NULL, plot=T, type="l", lty=2, lwd=3, fast.plot=F){
  source(file=system.file("extdata","RGB.rescale.R", package = "FIELDimageR", mustWork = TRUE))
  mosaic <- stack(mosaic)
  num.band<-length(mosaic@layers)
  print(paste(num.band," layers available", sep = ""))
  par(mfrow=c(1,2))
  if(!is.null(DSMmosaic)){
    par(mfrow=c(1,3))
    if(projection(DSMmosaic)!=projection(mosaic)){stop("DSMmosaic and RGBmosaic must have the same projection CRS")}}
  if(plot|is.null(theta)){
    if(fast.plot){
      raster::plot(mosaic[[1]], col=grey(1:100/100), axes=FALSE, box=FALSE, legend=FALSE)}
    if(!fast.plot){
  if(num.band>2){plotRGB(RGB.rescale(mosaic,num.band=3), r = 1, g = 2, b = 3)}
  if(num.band<3){raster::plot(mosaic, axes=FALSE, box=FALSE)}}}
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
    if (is.null(n.core)) {
    r<-rotate(mosaic,angle = theta)
  }
  if (!is.null(n.core)) {
    if (n.core > detectCores()) {
      stop(paste(" 'n.core' must be less than ", detectCores(),sep = ""))
    }
    cl <- parallel::makeCluster(n.core, output = "", setup_strategy = "sequential")
    registerDoParallel(cl)
    r <- foreach(i = 1:length(mosaic@layers), .packages = c("raster")) %dopar% {rotate(mosaic[[i]], angle = theta)}
  }
  r <- stack(r)
  if(extent){
    m11<-apply(as.matrix(raster::extent(mosaic)),1,function(x){sum(x)/2})
    m22<-apply(as.matrix(raster::extent(r)),1,function(x){c(x[2]-x[1])/2})
    raster::extent(r)<-raster::extent(c(m11[1]-m22[1]), c(m11[1]+m22[1]), c(m11[2]-m22[2]), c(m11[2]+m22[2]))
    crs(r)<-crs(mosaic)
  }
  Out<-r
  if(plot){
    if(fast.plot){
      raster::plot(r[[1]], col=grey(1:100/100), axes=FALSE, box=FALSE, legend=FALSE)}
    if(!fast.plot){
    if(num.band>2){plotRGB(RGB.rescale(r,num.band=3), r = 1, g = 2, b = 3)}
    if(num.band<3){raster::plot(r, axes=FALSE, box=FALSE)}}}
  if(!is.null(DSMmosaic)){
    DSMmosaic <- stack(DSMmosaic)
    DSMmosaic<-rotate(DSMmosaic,angle = theta)
    raster::plot(DSMmosaic, axes=FALSE, box=FALSE)
    if(extent){
    raster::extent(DSMmosaic)<-raster::extent(m11[1]-m22[1], m11[1]+m22[1], m11[2]-m22[2], m11[2]+m22[2])
    crs(DSMmosaic)<-crs(mosaic)
    }
    Out<-list(rotatedMosaic=r,rotatedDSM=DSMmosaic)
  }
  par(mfrow=c(1,1))
  return(Out)
}
