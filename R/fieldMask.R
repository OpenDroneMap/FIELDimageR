fieldMask<-function(mosaic,Blue=1,Green=2,Red=3,RedEdge=NULL,NIR=NULL,mask=NULL,index="HUE",cropValue=0,cropAbove=T, DSMmosaic=NULL, DSMcropAbove=T, DSMcropValue=0, plot=T){
  Ind<-read.csv(file=system.file("extdata", "Indices.txt", package = "FIELDimageR", mustWork = TRUE),header = T,sep = "\t")
  source(file=system.file("extdata","RGB.rescale.R", package = "FIELDimageR", mustWork = TRUE))
  mosaic <- stack(mosaic)
  num.band<-length(mosaic@layers)
  print(paste(num.band," bands available", sep = ""))
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
    B<-mosaic@layers[[Blue]]
    G<-mosaic@layers[[Green]]
    R<-mosaic@layers[[Red]]
    names(mosaic)[c(Blue,Green,Red)]<-c("Blue","Green","Red")
    if(!is.null(RedEdge)){
      RE<-mosaic@layers[[RedEdge]]
      names(mosaic)[RedEdge]<-c("RedEdge")
    }
    if(!is.null(NIR)){
      NIR1<-mosaic@layers[[NIR]]
      names(mosaic)[NIR]<-c("NIR")
    }
    mr<-eval(parse(text = as.character(Ind$eq[as.character(Ind$index)==index])))}

  if(!is.null(mask)){
    mask <- stack(mask)
    if(length(mask@layers)>1){stop("Mask must have only one band.")}
    mr<-mask
    mosaic<-crop(x = mosaic, y = mr)
    mosaic<- projectRaster(mosaic,mr,method = 'ngb')
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
  if(num.band<3){raster::plot(mosaic, axes=FALSE, box=FALSE)}
  raster::plot(m, col=grey(1:100/100), axes=FALSE, box=FALSE)}

  mosaic <- mask(mosaic, m, maskvalue=TRUE)

  if(plot){if(num.band>2){plotRGB(RGB.rescale(mosaic,num.band=3), r = 1, g = 2, b = 3)}
    if(num.band<3){raster::plot(mosaic, axes=FALSE, box=FALSE)}}

  mosaic <- stack(mosaic)
  m <- stack(m)
  Out<-list(newMosaic=mosaic,mask=m)
  if(!is.null(DSMmosaic)){
    DSMmosaic <- crop(x = DSMmosaic, y = m)
    if(DSMcropAbove){
      mDEM<-m>DSMcropValue
    }
    if(!DSMcropAbove){
      mDEM<-m<DSMcropValue
    }
    DSMmosaic <- projectRaster(DSMmosaic,mDEM,method = 'ngb')
    DSMmosaic <- mask(DSMmosaic, mDEM, maskvalue=TRUE)
    if(plot){raster::plot(DSMmosaic, axes=FALSE, box=FALSE)}
    DSMmosaic <- stack(DSMmosaic)
    Out<-list(newMosaic=mosaic,mask=m,DSM=DSMmosaic)
  }
  par(mfrow=c(1,1))
  return(Out)
}

