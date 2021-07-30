#' fieldArea
#' 
#' @title Percentage of object area 
#' 
#' @description It calculates the percentage of object area in the entire mosaic or per plot using the fieldShape file.
#' 
#' @param mosaic object mask of class stack from the function \code{\link{fieldMask}}.
#' @param areaValue referent value of object area in the image.
#' @param fieldShape evaluate the object area percentage per plot using the fieldShape as reference. If fieldShape=NULL, 
#'  the object area percentage will be calculated directly for the entire original image.
#' @param buffer negative values should be used to remove boundaries from neighbor plot 
#'  (normally the unit is meters, please use values as 0.1 = 10 cm).
#' @param n.core number of cores to use for multicore processing (Parallel).
#' @param plot if is TRUE the crop image and fieldShape will be plotted.
#' @param na.rm logical. Should missing values (including NaN) be used?. 
#' 
#' @importFrom raster stack extract crop
#' @importFrom parallel detectCores
#' @importFrom graphics par 
#' @importFrom foreach %dopar% foreach
#' @importFrom doParallel registerDoParallel
#' @importFrom grDevices grey
#'
#' 
#'
#' @return A list with two element
#' \itemize{
#'   \item \code{areaPorcent} is the percentage of object area per plot represented in \code{DataFrame}.
#'   \item \code{fieldShape} is the new \code{fieldShape} format \code{SpatialPolygonsDataFrame}.
#' }
#' 
#'
#' @export
fieldArea <- function(mosaic, areaValue = 0, fieldShape = NULL, buffer = NULL, n.core = NULL, plot = TRUE, na.rm = FALSE) {
  mosaic <- stack(mosaic)
  num.band<-length(mosaic@layers)
  print(paste(num.band," layer available", sep = ""))
  print(paste("You can speed up this step using n.core=", detectCores(), " or less.", sep = ""))
  if(num.band>1){stop("Only mask mosaic with values of 1 and 0 can be evaluated, please use the mask output from fieldMask()")}
  if(!areaValue%in%c(1,0)){stop("The value must be 1 or 0 to represent the objects in the mask mosaic, please use the mask output from fieldMask()")}
  pc <- function(x, p){return( data.frame(objArea=(length(x[x == p])/length(x[!is.na(x)])),objNumCell=length(x[x == p]),naNumCell=length(x[!is.na(x)])) )}
  if (na.rm){mosaic[is.na(mosaic)] <- c(0, 1)[c(0, 1) != areaValue]}
  if(is.null(fieldShape)){
    print("Evaluating the object area percentage for the whole image...")
    porarea<-pc(x=mosaic, p=areaValue)
    print(paste("The percentage of object area is ",100*(round(porarea$objArea,2)),"%",sep = ""))
    Out<-list(areaPorcent=porarea)
  }
  if(plot){
    withr::local_par(mfrow = c(1, 1))
    raster::plot(mosaic, col=grey(1:100/100), axes=FALSE, box=FALSE)}
  if(!is.null(fieldShape)){
    print("Evaluating the object area percetage per plot...")
    
    if (is.null(n.core)) {
      extM <- extract(x = mosaic, y = fieldShape, buffer = buffer)
      names(extM) <- 1:length(fieldShape)
      porarea <- as.data.frame(do.call(rbind,lapply(extM, pc, p = areaValue)))
    }
    if (!is.null(n.core)) {
      if(n.core>detectCores()){stop(paste(" 'n.core' must be less than ",detectCores(),sep = ""))}
      cl <- parallel::makeCluster(n.core, output = "", setup_strategy = "sequential")
      registerDoParallel(cl)
      i = 1:length(fieldShape)
      extM <- foreach(i, .packages = c("raster")) %dopar% 
        {
          single <- fieldShape[i, ]
          CropPlot <- crop(x = mosaic, y = single)
          extract(x = CropPlot, y = single, buffer = buffer)
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
