getInfo<-function(mosaic,fieldShape,fun = "mean",plot=F,buffer=NULL,n.core=NULL,...){ # buffer is in the mosaic unit, usually in meters.
  source(file=system.file("extdata","RGB.rescale.R", package = "FIELDimageR", mustWork = TRUE))
  if(projection(fieldShape)!=projection(mosaic)){stop("fieldShape and mosaic must have the same projection CRS. Use fieldRotate() for both files.")}
  mosaic <- stack(mosaic)
  num.band<-length(mosaic@layers)
  print(paste( "Extracting: ", num.band, " layers.", sep = ""))
  print(paste("You can speed up this step using n.core=", detectCores(), " or less.", sep = ""))
  CropPlot <- crop(x = mosaic, y = fieldShape)
  if(is.null(n.core)){
    plotValue <- extract(x = CropPlot, y = fieldShape, fun = eval(parse(text = fun)),
                         buffer = buffer, na.rm = T, df = T, ...)}
  if(!is.null(n.core)){
    if(n.core>detectCores()){stop(paste(" 'n.core' must be less than ",detectCores(),sep = ""))}
  cl <- makeCluster(n.core, output="")
  registerDoParallel(cl)
  plotValue <- foreach(i=1:length(fieldShape), .packages= c("raster"), .combine = rbind) %dopar% {
    single <- fieldShape[i,]
    CropPlot <- crop(x = mosaic, y = single)
    extract(x = CropPlot, y = single, fun = eval(parse(text = fun)),buffer = buffer, na.rm = T, df = T, ...)}
  plotValue$ID<-1:length(fieldShape)}
  fieldShape@data<-cbind.data.frame(fieldShape@data,plotValue)
  Out<-list(fieldShape=fieldShape,plotValue=plotValue,cropPlot=CropPlot)
  if(plot){
    if(num.band>2){plotRGB(RGB.rescale(CropPlot, num.band=3), r = 1, g = 2, b = 3)}
    if(num.band<3){raster::plot(CropPlot, axes=FALSE, box=FALSE)}
    sp::plot(fieldShape, add=T)
  }
  return(Out)}
