#' fieldInfo 
#' 
#' @title Extract information from image using the fieldShape file as reference
#' 
#' @description Function that use \code{raster::extract()} to extract information from the original 
#' image using fieldShape file as reference.
#' 
#' @param mosaic object of class stack.
#' @param fieldShape plot shape file, please use first the function \code{\link{fieldShape}}. 
#' @param fun to summarize the values (e.g. mean).
#' @param plot if is TRUE the original and crop image will be plotted.
#' @param buffer negative values should be used to remove boundaries from neighbor plot 
#'  (normally the unit is meters, please use values as 0.1 = 10 cm). 
#' @param n.core number of cores to use for multicore processing (Parallel).
#' @param projection if is FALSE projection will be ignored.
#' 
#' @importFrom graphics par
#' @importFrom utils read.csv
#' 
#' @return A list with a data frame with values by plot and experimental field image with format stack.
#'
#' @export
fieldInfo <- function(mosaic, fieldShape, fun = "mean", plot = FALSE, buffer = NULL,
                      n.core = NULL, projection = TRUE) { # buffer is in the mosaic unit, usually in meters.
  if(projection){if(projection(fieldShape)!=projection(mosaic)){stop("fieldShape and mosaic must have the same projection CRS. Use fieldRotate() for both files.")}}
  mosaic <- stack(mosaic)
  num.band<-length(mosaic@layers)
  print(paste( "Extracting: ", num.band, " layers.", sep = ""))
  print(paste("You can speed up this step using n.core=", detectCores(), " or less.", sep = ""))
  CropPlot <- crop(x = mosaic, y = fieldShape)
  if(is.null(n.core)){
    plotValue <- extract(x = CropPlot, y = fieldShape, fun = eval(parse(text = fun)),
                         buffer = buffer, na.rm = T, df = T)}
  if(!is.null(n.core)){
    if(n.core>detectCores()){stop(paste(" 'n.core' must be less than ",detectCores(),sep = ""))}
    cl <- parallel::makeCluster(n.core, output = "", setup_strategy = "sequential")
    registerDoParallel(cl)
    plotValue <- foreach(i=1:length(fieldShape), .packages= c("raster"), .combine = rbind) %dopar% {
      single <- fieldShape[i,]
      CropPlot <- crop(x = mosaic, y = single)
      extract(x = CropPlot, y = single, fun = eval(parse(text = fun)),buffer = buffer, na.rm = T, df = T)}
    plotValue$ID<-1:length(fieldShape)}
  fieldShape@data<-cbind.data.frame(fieldShape@data,plotValue)
  Out<-list(fieldShape=fieldShape,plotValue=plotValue,cropPlot=CropPlot)
  if(plot){
    if(num.band>2){plotRGB(RGB.rescale(CropPlot, num.band=3), r = 1, g = 2, b = 3)}
    if(num.band<3){raster::plot(CropPlot, axes=FALSE, box=FALSE)}
    sp::plot(fieldShape, add=T)
  }
  return(Out)
}
