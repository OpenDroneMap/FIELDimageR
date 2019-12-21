fieldCrop<-function(mosaic, fieldShape=NULL, nPoint=4, plot=T, remove=F, type="l", lty=2, lwd=3){
  source(file=system.file("extdata","RGB.rescale.R", package = "FIELDimageR", mustWork = TRUE))
  mosaic <- stack(mosaic)
  num.band<-length(mosaic@layers)
  print(paste(num.band," layers available", sep = ""))
  if(nPoint<4|nPoint>50){stop("nPoint must be >= 4 and <= 50")}
  par(mfrow=c(1,2))
  if(is.null(fieldShape)|plot){
  if(num.band>2){plotRGB(RGB.rescale(mosaic,num.band=3), r = 1, g = 2, b = 3)}
  if(num.band<3){raster::plot(mosaic, axes=FALSE, box=FALSE)}
  }
  if(!is.null(fieldShape)){
    if(projection(fieldShape)!=projection(mosaic)){stop("fieldShape and mosaic must have the same projection CRS. Use fieldRotate() for both files.")}
    r <- crop(x = mosaic, y = fieldShape)
  }
  c1<-NULL
  if(is.null(fieldShape)){
    print(paste("Select ",nPoint," points at the corners of field of interest in the plots space.",sep = ""))
    for(i in 1:nPoint){
      c1.1<-locator(type="p",n = 1, col="red",pch=19)
      c1<-rbind(c1,c(c1.1$x,c1.1$y))
    }
    c1<-rbind(c1,c1[1,])
    colnames(c1)<-c("x","y")
    lines(c1, col= "red", type=type, lty=lty, lwd=lwd)
    }
    if(!is.null(c1)){
    p1 <- Polygons(list(Polygon(c1)), "x")
    f1 <- SpatialPolygonsDataFrame( SpatialPolygons(list(p1)), data.frame( z=1, row.names=c("x") ) )
    projection(f1) <- projection(mosaic)
    if(!remove){r <- crop(x = mosaic, y = f1)}
    if(remove){r <- mask(x = mosaic, mask = f1, inverse = remove)}
  }
  r <- stack(r)
  if(plot){
    if(num.band>2){plotRGB(RGB.rescale(r,num.band=3), r = 1, g = 2, b = 3)}
    if(num.band<3){raster::plot(r, axes=FALSE, box=FALSE)}}
  par(mfrow=c(1,1))
  return(r)
}
