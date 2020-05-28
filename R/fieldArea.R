fieldArea<-function(mosaic, areaValue=0, fieldShape=NULL, n.core=NULL, plot=T){
  mosaic <- stack(mosaic)
  num.band<-length(mosaic@layers)
  print(paste(num.band," layer available", sep = ""))
  print(paste("You can speed up this step using n.core=", detectCores(), " or less.", sep = ""))
  if(num.band>1){stop("Only mask mosaic with values of 1 and 0 can be evaluated, please use the mask output from fieldMask()")}
  if(!areaValue%in%c(1,0)){stop("The value must be 1 or 0 to represent the objects in the mask mosaic, please use the mask output from fieldMask()")}
  pc <- function(x, p){return( data.frame(objArea=(length(x[x == p])/length(x[!is.na(x)])),objNumCell=length(x[x == p]),naNumCell=length(x[!is.na(x)])) )}
  if(is.null(fieldShape)){
    print("Evaluating the object area percentage for the whole image...")
    porarea<-pc(x=mosaic, p=areaValue)
    print(paste("The percentage of object area is ",100*(round(porarea$objArea,2)),"%",sep = ""))
    Out<-list(areaPorcent=porarea)
  }
  if(plot){raster::plot(mosaic, col=grey(1:100/100), axes=FALSE, box=FALSE)}
  if(!is.null(fieldShape)){
    print("Evaluating the object area percetage per plot...")
    
    if (is.null(n.core)) {
      extM <- extract(x = mosaic, y = fieldShape)
      names(extM) <- 1:length(fieldShape)
      porarea <- as.data.frame(do.call(rbind,lapply(extM, pc, p = areaValue)))
    }
    if (!is.null(n.core)) {
      if(n.core>detectCores()){stop(paste(" 'n.core' must be less than ",detectCores(),sep = ""))}
      cl <- makeCluster(n.core, output = "")
      registerDoParallel(cl)
      extM <- foreach(i = 1:length(fieldShape), .packages = c("raster")) %dopar% 
        {
          single <- fieldShape[i, ]
          CropPlot <- crop(x = mosaic, y = single)
          extract(x = CropPlot, y = single)
        }
      names(extM) <- 1:length(fieldShape)
      porarea <- as.data.frame(do.call(rbind,lapply(extM, function(x){pc(as.numeric(x[[1]]),p = areaValue)})))
    }
    fieldShape@data<-cbind.data.frame(fieldShape@data,porarea)
    Out<-list(areaPorcent=porarea, fieldShape=fieldShape)
    if(plot){sp::plot(fieldShape, add = T)}
  }
  return(Out)
}
