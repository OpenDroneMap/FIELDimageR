fieldPlot<-function(fieldShape,fieldAttribute, mosaic=NULL, color=c("white","black"), alpha = 0.5, legend.position="right"){
  source(file=system.file("extdata","RGB.rescale.R", package = "FIELDimageR", mustWork = TRUE))
  if(length(fieldAttribute)>1){stop("Choose ONE attribute")}
  attribute<-colnames(fieldShape@data)
  if(!fieldAttribute%in%attribute){stop(paste("Attribute ",fieldAttribute," is not valid. Choose one among: ", unique(attribute), sep = ""))}
  val<-as.numeric(fieldShape@data[,which(attribute%in%fieldAttribute)[1]])
  val[is.na(val)] <- 0
  rr <- range(val)
  svals <- (val-rr[1])/diff(rr)
  f <- colorRamp(color)
  valcol <- rgb(f(svals)/255, alpha = alpha)
  if(!is.null(mosaic)){
    if(projection(fieldShape)!=projection(mosaic)){stop("fieldShape and mosaic must have the same projection CRS. Use fieldRotate() for both files.")}
    mosaic <- stack(mosaic)
    num.band<-length(mosaic@layers)
    if(num.band>2){plotRGB(RGB.rescale(mosaic,num.band=3), r = 1, g = 2, b = 3)}
    if(num.band<3){raster::plot(mosaic, axes=FALSE, box=FALSE)}
    sp::plot(fieldShape, col= valcol, add = T)
  }
  if(is.null(mosaic)){
    sp::plot(fieldShape, col= valcol)}
  pos <- seq(min(val), max(val), length.out = 5)
  legend(legend.position,
         title= fieldAttribute,
         legend = round(pos,3),
         fill =  rgb(f(c(0.00,0.25,0.50,0.75,1.00))/255, alpha = alpha),
         bty = "n")
}

