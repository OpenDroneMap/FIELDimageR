canopy<-function(mosaic, canopyValue=0, fieldShape=NULL, n.core=NULL, plot=T){
  mosaic <- stack(mosaic)
  num.band<-length(mosaic@layers)
  print(paste(num.band," layer available", sep = ""))
  if(n.core>detectCores()){stop(paste(" 'n.core' must be less than ",detectCores(),sep = ""))}
  print(paste("You can speed up this step using n.core=", detectCores(), " or less.", sep = ""))
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
    
    if (is.null(n.core)) {
      extM <- extract(x = mosaic, y = fieldShape)
      names(extM) <- 1:length(fieldShape)
      porCanopy <- unlist(lapply(extM, pc, p = canopyValue))
    }
    if (!is.null(n.core)) {
      cl <- makeCluster(n.core, output = "")
      registerDoParallel(cl)
      extM <- foreach(i = 1:length(fieldShape), .packages = c("raster")) %dopar% 
        {
          single <- fieldShape[i, ]
          CropPlot <- crop(x = mosaic, y = single)
          extract(x = CropPlot, y = single)
        }
      names(extM) <- 1:length(fieldShape)
      porCanopy <- unlist(lapply(extM, function(x){pc(as.numeric(x[[1]]),p = canopyValue)}))
    }
    fieldShape@data$canopyPorcent=porCanopy
    Out<-list(canopyPorcent=porCanopy, fieldShape=fieldShape)
    if(plot){sp::plot(fieldShape, add = T)}
  }
  return(Out)
}
