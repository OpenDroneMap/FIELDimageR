fieldShape<-function(mosaic,ncols=10,nrows=10,nPoint=4,fieldMap=NULL,fieldData=NULL,ID=NULL,plot=T){
  source(file=system.file("extdata","RGB.rescale.R", package = "FIELDimageR", mustWork = TRUE))
  mosaic <- stack(mosaic)
  num.band<-length(mosaic@layers)
  print(paste(num.band," bands available", sep = ""))
  if(nPoint<4|nPoint>50){stop("nPoint must be >= 4 and <= 50")}
  par(mfrow=c(1,2))
  if(num.band>2){plotRGB(RGB.rescale(mosaic,num.band=3), r = 1, g = 2, b = 3)}
  if(num.band<3){raster::plot(mosaic, axes=FALSE, box=FALSE)}
  print(paste("Select ",nPoint," points at the corners of field of interest in the plots space.",sep = ""))
  c1<-NULL
  for(i in 1:nPoint){
    c1.1<-locator(type="p",n = 1, col="red",pch=19)
    c1<-rbind(c1,c(c1.1$x,c1.1$y))
  }
  c1<-rbind(c1,c1[1,])
  colnames(c1)<-c("x","y")
  lines(c1, col= "red", type="l", lty=2, lwd=3)
  p1 <- Polygons(list(Polygon(c1)), "x")
  f1 <- SpatialPolygonsDataFrame( SpatialPolygons(list(p1)), data.frame( z=1, row.names=c("x") ) )
  projection(f1) <- projection(mosaic)
  r <- crop(x = mosaic, y = f1)
  r <- stack(r)
  grid <- raster(f1,nrows=nrows, ncols=ncols,crs = proj4string(r))
  fieldShape <- rasterToPolygons(grid)
  if(plot){
    if(num.band>2){
      plotRGB(RGB.rescale(r,num.band=3), r = 1, g = 2, b = 3)
      sp::plot(fieldShape, add = T)
    }
    if(num.band<3){
      raster::plot(r, axes=FALSE, box=FALSE)
      sp::plot(fieldShape, add = T)}}
  fieldShape@data<-data.frame(fieldID=as.character(seq(1,length(fieldShape$layer))))
if(!is.null(fieldMap)){fieldShape@data<-data.frame(PlotName=as.character(c(t(fieldMap))))}
if(!is.null(fieldData)){
  fieldData<-as.data.frame(fieldData)
  if(is.null(ID)){stop("Choose one ID (column) to combine fieldData with fiedShape")}
  if(length(ID)>1){stop("Choose only one ID")}
  if(is.null(fieldMap)){stop("fieldMap is necessary, please use function fieldMap()")}
  if(!as.character(ID)%in%as.character(colnames(fieldData))){stop(paste("ID: ",ID," is not valid."))}
  fieldData$PlotName<-as.character(fieldData[,colnames(fieldData)==ID])
  fieldShape@data<-plyr::join(fieldShape@data,fieldData,by="PlotName")
  }
  Out<-list(fieldShape=fieldShape,cropField=r)
  par(mfrow=c(1,1))
  return(Out)
}
