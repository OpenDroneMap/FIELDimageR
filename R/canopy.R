canopy<-function(mosaic, canopyValue=0, fieldShape=NULL, plot=T){
  mosaic <- stack(mosaic)
  num.band<-length(mosaic@layers)
  print(paste(num.band," band available", sep = ""))
  if(num.band>1){stop("Only mask mosaic with values of 1 and 0 can be evaluated, please use the mask output from fieldMask()")}
  if(!canopyValue%in%c(1,0)){stop("The value must be 1 or 0 to represent the plants in the mask mosaic, please use the mask output from fieldMask()")}
  pc <- function(x, p){return( length(x[x == p]) / length(x[!is.na(x)]) )}
  if(is.null(fieldShape)){
    print("Evaluating the canopy percentage for the whole image...")
    porCanopy<-pc(x=mosaic, p=canopyValue)
    print(paste("The percentage of canopy is ",100*(round(porCanopy,2)),"%",sep = ""))
    Out<-porCanopy
  }
  if(plot){raster::plot(mosaic, col=grey(1:100/100), axes=FALSE, box=FALSE)}
  if(!is.null(fieldShape)){
    print("Evaluating the canopy percetage per plot...")
    extM<-extract(mosaic, fieldShape)
    porCanopy<-unlist(lapply(extM, pc, p=canopyValue))
    fieldShape@data$canopyPorcent=porCanopy
    Out<-list(canopyPorcent=porCanopy, fieldShape=fieldShape)
    if(plot){sp::plot(fieldShape, add = T)}
  }
  return(Out)
}
