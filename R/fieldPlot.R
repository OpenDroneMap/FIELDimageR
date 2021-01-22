fieldPlot<-function(fieldShape,fieldAttribute, mosaic=NULL, color=c("white","black"), min.lim=NULL, max.lim=NULL, alpha = 0.5, legend.position="right", na.color="gray", classes=5, round=3, horiz = F){
  source(file=system.file("extdata","RGB.rescale.R", package = "FIELDimageR", mustWork = TRUE))
  if(length(fieldAttribute)>1){stop("Choose ONE attribute")}
  attribute<-colnames(fieldShape@data)
  if(!fieldAttribute%in%attribute){stop(paste("Attribute ",fieldAttribute," is not valid. Choose one among: ", unique(attribute), sep = ""))}
  val<-as.numeric(fieldShape@data[,which(attribute%in%fieldAttribute)[1]])
  if(!c(is.null(min.lim)&is.null(max.lim))){
    if (!c(is.numeric(min.lim)&is.numeric(max.lim))) {
      stop("Limit need to be numeric e.g. min.lim=0 and max.lim=1")
    }
    if (min.lim > min(val, na.rm = T)) {
      stop(paste("Choose minimum limit equal or lower than ",min(val,na.rm = T), sep=""))
    }
    if (max.lim < max(val, na.rm = T)) {
      stop(paste("Choose maximum limit equal or greater than ",max(val,na.rm = T), sep=""))
    }
    val<-c(min.lim,val,max.lim)
  }
  na.pos<-is.na(val)
  rr <- range(val,na.rm=T)
  svals <- (val-rr[1])/diff(rr)
  f <- colorRamp(color)
  svals[na.pos] <- 0
  valcol <- rgb(f(svals)/255, alpha = alpha)
  valcol[na.pos] <- rgb(t(col2rgb(col = na.color, alpha = FALSE))/255,alpha = alpha)
  if(!c(is.null(min.lim)&is.null(max.lim))){valcol<-valcol[-c(1,length(valcol))]}
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
  pos <- round(seq(min(val,na.rm = T), max(val,na.rm = T), length.out = classes),round)
  if(any(na.pos)){pos=c(pos,"NA")}
  col<-rgb(f(seq(0, 1, length.out = classes))/255, alpha = alpha)
  if(any(na.pos)){col=c(col,rgb(t(col2rgb(col = na.color, alpha = FALSE))/255,alpha = alpha))}
  legend(legend.position,
         title= fieldAttribute,
         legend = pos,
         fill =  col,
         bty = "n",
        horiz = horiz)
}

